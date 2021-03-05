function_in_another_file :: () {
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