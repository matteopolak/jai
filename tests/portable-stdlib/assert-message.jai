#import "Basic";

calls: int;
received: string;
received_location: Source_Code_Location;
answer: bool;

capture :: (location: Source_Code_Location, message: string) -> bool {
    calls += 1;
    received = message;
    received_location = location;
    return answer;
}

main :: () {
    push_context {
        context.assertion_failed = capture;
        assert(true, "must not dispatch %", 7);
        if calls != 0 exit(1);

        assert(false, "value % / %", 7, "text");
        if calls != 1 || received != "value 7 / text" exit(2);
        if received_location.line_number <= 0 exit(3);

        answer = true;
        if !assert_helper("answer %", 9) exit(4);
        if calls != 2 || received != "answer 9" exit(5);
    }

    print("ok\n");
}
