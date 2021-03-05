#import "Basic";

#load "other.jai";

truth :: () -> bool { return true; }
lies :: () -> bool { return false; }

main :: () {

    //
    // OK return statements
    //

    good_function_call :: () -> bool {
        t := truth();
        return t;
    }

    //
    // DISALLOWED return statements
    //

    // bad_function_call :: () -> bool {
    //     return truth();
    // }

    //
    // OK if statements
    //

    if false {}
    if !true {}
    if true && true || true {}
    if 42 {}
    if "hello" {}

    //
    // DISALLOWED if statements
    //

    // if truth() {}
    // if !!true {}
    // if true && true && true && true && true && true {}
    // if true && true && true && true && truth() {}
}
