#import "Basic";
#import "Sound_Player";

main :: () {
    config: Sound_Player_Config;
    config.update_from_a_thread = false;
    devices := backend_get_devices();
    for device: devices assert(device.name.count > 0);

    properties := backend_init(config);
    if properties.initted {
        print("native-device-opened\n");
        assert(properties.num_channels == 2 && properties.output_sampling_rate > 0);
        bytes, minimum := backend_count_buffered_bytes();

        assert(bytes == 0 && minimum > 0);
        regions, success := backend_lock_fill_regions(1024);

        assert(success && regions.buffer0.count == 1024 && regions.buffer1.count == 0);
        memset(regions.buffer0.data, 0, regions.buffer0.count);
        backend_release_fill_regions(regions);
        bytes, minimum = backend_count_buffered_bytes();
        assert(bytes >= 0);
        backend_play();
        sleep_milliseconds(20);
    } else {
        print("native-device-unavailable\n");
        regions, success := backend_lock_fill_regions(1024);
        assert(!success && regions.buffer0.count == 0);
    }

    backend_shutdown();
    backend_shutdown();
    print("ok\n");
}
