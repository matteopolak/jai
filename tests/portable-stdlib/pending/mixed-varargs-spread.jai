#import "Basic";
P :: #import "Process";

main :: () {
    args := string.["%s", "tail"];
    result, out, err, timed := P.run_command("/usr/bin/printf", ..args, capture_and_return_output = true);

    defer free(out);
    defer free(err);
    print("mixed spread: type %, exit %, stdout [%], stderr [%]\n", cast(s64) result.type, result.exit_code, out, err);
    assert(result.type == .EXITED && result.exit_code == 0 && !timed && out == "tail" && err == "");
}
