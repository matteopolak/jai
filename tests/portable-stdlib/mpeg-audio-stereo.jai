#import "Basic";
M :: #import "pl_mpeg";
S :: #import "String";

main :: () {
    #assert !#exists(M.read_quantized);
    #assert !#exists(M.scale_samples);
    root := sprint("%/../../target/portable-tests/mpeg/", S.path_strip_filename(#file));

    defer free(root);
    names := string.["stereo", "dual", "joint"];
    for names {
        filename := sprint("%%.mp2", root, it);
        buffer := M.buffer_create_with_filename(filename);

        free(filename);
        assert(buffer != null);
        audio := M.audio_create_with_buffer(buffer, true);

        assert(audio.has_header && audio.mode != .MONO);

        for round: 0..1 {
            peak: float;

            for block: 0..1 {
                samples := M.audio_decode(audio);

                assert(samples != null && samples.count == 1152);

                for i: 0..1151 {
                    left := samples.interleaved[i * 2];
                    right := samples.interleaved[i * 2 + 1];

                    assert(left >= -1 && left <= 1 && right >= -1 && right <= 1);
                    difference := right - left * 0.25;

                    assert(difference > -0.000001 && difference < 0.000001);
                    magnitude := left;
                    if magnitude < 0 magnitude = -magnitude;
                    if magnitude > peak peak = magnitude;
                }
            }

            assert(peak > 0.01);
            assert(M.audio_decode(audio) == null);
            if round == 0 M.audio_rewind(audio);
        }

        M.audio_destroy(audio);
    }

    print("ok\n");
}
