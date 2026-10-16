// Calls unchanged owned Json test procedures, retaining their counts and assertions.
#import "Basic";
#import "Extensions/Json";
N :: #import, file "../../../stdlib/Extensions/Json/tests/numbers.jai";

main :: () {
    for pass: 0..1 {
        json_use_simd = pass == 1;
        json_index_min_size = 0;
        print("pass % printing begin\n", pass);
        N.printing();
        print("pass % parsing begin\n", pass);
        N.parsing();
        print("pass % integers begin\n", pass);
        N.integers();

        if pass == 0 {
            print("random_round_trips 1000 begin\n");
            N.random_round_trips(1000);
            print("shortest_matches_exact 400 begin\n");
            N.shortest_matches_exact(400);
            print("fast_path_agrees 600 begin\n");
            N.fast_path_agrees(600);
        }

        print("pass % complete\n", pass);
    }

    assert(N.failures == 0);
    print("ok\n");
}
