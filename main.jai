#import "Basic";

truth :: () -> bool { return true; }
lies :: () -> bool { return false; }

main :: () {

    //
    // GOOD code
    //

    a_variable := 43;
    if false {}
    if !true || !false{}
    if true && true || true {}
    if 42 {}
    value := true; if value {}
    good_function_call :: () -> bool { t := truth(); return t; }

    //
    // DISALLOWED code
    //

    bad_Function_Name :: () {}
    bad_fuCction_name :: () {}
    bad_function_call :: () -> bool { return truth(); }
    if "hello" {}
    if truth() {}
    if !!true {}
    if !true || !!false{}
    if true != true || true == true && truth() {}

    //
    // @Incomplete errors not caught
    //

    A_Variable := 42; // Should be lower_snake_case
    a_constant :: 42; // Should be ALLCAPS_SNAKE_CASE
}
