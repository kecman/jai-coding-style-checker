#import "Basic";

truth :: () -> bool { return true; }
lies :: () -> bool { return false; }

main :: () {

    //
    // GOOD code
    //

    good_function_call :: () -> bool {
        t := truth();
        return t;
    }
    if false {}
    if !true || !false{}
    if true && true || true {}
    if 42 {}
    if "hello" {}

    //
    // DISALLOWED code
    //

    // bad_function_call :: () -> bool {
    //     return truth();
    // }
    // if truth() {}
    // if !!true {}
    // if !true || !!false{}
    // if true != true || true == true && truth() {}
}
