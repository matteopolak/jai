#import "Basic";
#import "String";
main :: () {
    assert(wildcard_match("abcdef", "a*[c-e]?f"));
    assert(wildcard_match("", "***"));
    assert(wildcard_match("a*b", "a[*]b"));
    assert(!wildcard_match("ab", "a?b"));
    assert(!wildcard_match("a", "[b-d]"));
    assert(wildcard_match("zzabac", "*ab?c"));
    number: s64;
    flag: bool;
    text: string;
    real: float;
    assert(scan2("42 true \"words here\" 1.25%", "%d %b %s %f%%", *number, *flag, *text, *real));
    assert(number == 42 && flag && text == "words here" && real == 1.25);
    assert(!scan2("7 no", "%i %b", *number, *flag));
    assert(number == 7);
    ok, values := scan("%d %s", "-8 \"yes\"");
    assert(ok && values.count == 2);
    assert((cast(*s64)values[0].value_pointer).* == -8);
    assert((cast(*string)values[1].value_pointer).* == "yes");
    failed, partial := scan("%b !%d", "true ?5");
    assert(!failed && partial.count == 1);
    percent, unused := scan("%%", "%");
    assert(!percent && unused.count == 0);
    print("ok\n");
}
