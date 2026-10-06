// Loudness and placement: the listener frame, distance falloff, and the gain every source channel
// gets on every output channel.

// Perceived loudness (0..1) to amplitude. Halving the perceived level is a drop of about 10 dB,
// which makes the exponent log2(sqrt(10)).
perceptual_to_linear :: (x: float) -> float {
    LOUDNESS_EXPONENT :: 1.660964;
    return pow(x, LOUDNESS_EXPONENT);
}

// The listener is the camera: in camera space x points ahead, y to the left and z up.
update_listener :: (camera_position: Vector3, camera_orientation: Quaternion) {
    listener.origin = camera_position;
    listener.ahead = rotate(Vector3.{ 1, 0, 0 }, camera_orientation);
    listener.leftward = rotate(Vector3.{ 0, 1, 0 }, camera_orientation);
}

// Perceived loudness of `stream` if it were at `position`, before panning.
get_desired_volume_perceptual :: (stream: *Sound_Stream, position: Vector3) -> float {
    if !stream || !stream.sound_data return 0;
    level := master_volume * stream.user_volume_scale * stream.universe_volume_scale * stream.sound_data.volume_scale;
    slot := cast(s64) stream.category;
    if slot >= 0 && slot < MAX_SOUND_CATEGORIES level *= category_volume[slot];
    if stream.user_flags & .SPATIALIZED level *= falloff(stream, length(position - listener.origin));
    return max(level, 0.0);
}

#scope_module

Listener_Frame :: struct {
    origin: Vector3;
    ahead: Vector3 = .{ 1, 0, 0 };
    leftward: Vector3 = .{ 0, 1, 0 };
}
listener: Listener_Frame;

// Inside this distance a spatialized sound drifts toward the middle of a stereo image, so passing
// right through the listener does not flip it from ear to ear.
CENTERING_DISTANCE :: 4.0;

// Where each output speaker sits, in degrees counterclockwise from straight ahead (left is
// positive). Indexed by Audio_Channel; the subwoofer has no direction and is left out of panning.
SPEAKER_AZIMUTH :: float.[30, -30, 0, 0, 110, -110, 150, -150];

// The direction each Source_Direction stands for, and the speaker it plays on directly when the
// output has that speaker (-1: none, pan by direction instead).
SOURCE_AZIMUTH :: float.[0, 30, -30, 30, -30, 110, -110, 0, 0, 150, -150];
SOURCE_SPEAKER :: s32.[-1, 0, 1, 0, 1, 4, 5, 2, 3, 6, 7];

// Directional speakers of the current output, sorted by azimuth, for pairwise panning.
Ring_Speaker :: struct {
    channel: s32;
    azimuth: float;
}
speaker_ring: [OUTPUT_CHANNELS_MAX] Ring_Speaker;
speaker_ring_size: s32;

build_speaker_ring :: (channels: s32) {
    speaker_ring_size = 0;
    for channel: 0..channels - 1 {
        if channel == cast(s32) Audio_Channel.SUBWOOFER continue;
        entry := Ring_Speaker.{ cast(s32) channel, SPEAKER_AZIMUTH[channel] };
        slot := speaker_ring_size;
        while slot > 0 && speaker_ring[slot - 1].azimuth > entry.azimuth {
            speaker_ring[slot] = speaker_ring[slot - 1];
            slot -= 1;
        }
        speaker_ring[slot] = entry;
        speaker_ring_size += 1;
    }
}

falloff :: (stream: *Sound_Stream, distance: float) -> float {
    if distance <= stream.inner_radius return 1;
    if distance >= stream.outer_radius return 0;
    return (stream.outer_radius - distance) / (stream.outer_radius - stream.inner_radius);
}

// Recomputes the gains the mixer should be heading for. Lock held.
aim_gains :: (stream: *Sound_Stream) {
    voice := *stream.voice;
    for *voice.aim it.* = 0;

    level := perceptual_to_linear(get_desired_volume_perceptual(stream, stream.position));
    stream.inaudible = level <= 0.00001;

    // Music keeps its speaker layout even when it has a position; only its loudness follows it.
    placed := (stream.user_flags & .SPATIALIZED) && !(stream.user_flags & .MUSIC);
    bearing, nearness: float;
    if placed bearing, nearness = bearing_of(stream.position);

    for source: 0..stream.num_channels - 1 {
        row := voice.aim.data + source * OUTPUT_CHANNELS_MAX;
        direction := cast(s64) stream.sound_data.source_directions[source];
        if placed {
            azimuth := bearing;
            if stream.num_channels > 1 azimuth += SOURCE_AZIMUTH[direction];
            pan_into(row, azimuth, nearness, level);
            continue;
        }
        speaker := SOURCE_SPEAKER[direction];
        if speaker >= 0 && speaker < player.out_channels {
            row[speaker] += level;
        } else if direction == cast(s64) Source_Direction.SUBWOOFER_CENTER_FORWARD {
            // No subwoofer: split the bass over the front pair.
            row[0] += level * 0.5;
            if player.out_channels > 1 row[1] += level * 0.5;
        } else {
            pan_into(row, SOURCE_AZIMUTH[direction], 0, level);
        }
    }

    // Glide over a few milliseconds; a fresh stream starts at its target.
    glide_frames := max(1.0, player.out_rate * GAIN_GLIDE_SECONDS);
    for i: 0..voice.aim.count - 1 {
        if !voice.gains_settled voice.gain[i] = voice.aim[i];
        voice.slope[i] = (voice.aim[i] - voice.gain[i]) / glide_frames;
    }
    voice.gains_settled = true;
}

// Azimuth of `position` around the listener in degrees, and how close it is (1 at the listener,
// 0 from CENTERING_DISTANCE on).
bearing_of :: (position: Vector3) -> azimuth: float, nearness: float {
    offset := position - listener.origin;
    forward := dot(offset, listener.ahead);
    sideways := dot(offset, listener.leftward);
    azimuth := 0.0;
    if forward * forward + sideways * sideways > 0.000001 azimuth = atan2(sideways, forward) * (180.0 / PI);
    nearness := clamp(1 - length(offset) / CENTERING_DISTANCE, 0.0, 1.0);
    return azimuth, nearness;
}

// Adds `level` worth of signal arriving from `azimuth` to one row of output gains.
pan_into :: (row: *float, azimuth: float, nearness: float, level: float) {
    if player.out_channels == 1 {
        row[0] += level;
        return;
    }
    if speaker_ring_size < 3 {
        // Stereo: constant-power balance from the sideways component of the direction.
        balance := sin(azimuth * (PI / 180.0)) * (1 - nearness);
        row[0] += level * sqrt((1 + balance) * 0.5);
        row[1] += level * sqrt((1 - balance) * 0.5);
        return;
    }

    // Surround: find the neighbouring pair of speakers around the direction and share the signal
    // between them with a constant-power crossfade.
    angle := azimuth - 360.0 * floor((azimuth + 180.0) / 360.0); // Into [-180, 180).
    upper := 0;
    while upper < speaker_ring_size && speaker_ring[upper].azimuth <= angle upper += 1;
    below := speaker_ring[(upper + speaker_ring_size - 1) % speaker_ring_size];
    above := speaker_ring[upper % speaker_ring_size];

    gap := above.azimuth - below.azimuth;
    if gap <= 0 gap += 360;
    into := angle - below.azimuth;
    if into < 0 into += 360;
    fraction := clamp(into / gap, 0.0, 1.0) * (PI * 0.5);
    row[below.channel] += level * cos(fraction);
    row[above.channel] += level * sin(fraction);
}
