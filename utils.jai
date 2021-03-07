
is_lower_snake_case :: (s : string) -> bool
{
    remainder := s;
    while remainder.count {
        word : string;
        word, remainder = break_by_underscore(remainder);
        if contains_any(word, "ABCDEFGHIJKLMNOPQRSTUVXYZ") {
            return false;
        }
    }
    return true;
}

is_upper_snake_case :: (s : string) -> bool
{
    remainder := s;
    while remainder.count {
        word : string;
        word, remainder = break_by_underscore(remainder);
        if word && !contains_any("ABCDEFGHIJKLMNOPQRSTUVXYZ_", slice(word, 0, 1)) {
            return false;
        }
    }
    return true;
}

break_by_underscore :: (s : string) -> (left : string, right : string) {
    lhs := s;
    rhs := eat_until_underscore(s);
    lhs.count -= rhs.count;
    rhs = eat_underscores(rhs);
    return lhs, rhs;
}

eat_underscores :: (_s: string) -> string {
    s := _s;
    while s {
        if s[0] != #char "_" break;
        advance(*s, 1);
    }
    return s;
}

eat_until_underscore :: (_s: string) -> string {
    s := _s;
    while s {
        if s[0] == #char "_" break;
        advance(*s, 1);
    }
    return s;
}

// For debugging
print_exp :: (node : *Code_Node)
{
    builder: String_Builder;
    defer free_buffers(*builder);

    #import "Program_Print";
    print_expression(*builder, node);

    print("%\n", builder_to_string(*builder));
}

#run tests();

tests :: () {
    // a, b := break_by_underscore("aaa_bbb");
    // a, b := break_by_underscore("aaabbb");
    // a, b := break_by_underscore("_aaabbb");
    // a, b := break_by_underscore("aaabbb_");
    a, b := break_by_underscore("  ____Fd_");

    assert(is_lower_snake_case("_"));
    assert(is_lower_snake_case("_s"));
    assert(is_lower_snake_case("s_"));
    assert(is_lower_snake_case("s_"));
    assert(is_lower_snake_case("a_b_c"));
    assert(is_lower_snake_case("a___b__c"));
    assert(!is_lower_snake_case("A___b__C"));

    assert(is_upper_snake_case("_"));
    assert(is_upper_snake_case("_S"));
    assert(is_upper_snake_case("S_"));
    assert(is_upper_snake_case("S_"));
    assert(is_upper_snake_case("A_B_C"));
    assert(is_upper_snake_case("A___B__C"));
    assert(!is_upper_snake_case("A___b__C"));

    // assert(is_lower_snake_case("a_b_c"));
    // assert(is_lower_snake_case("a_b_c"));
    // assert(is_lower_snake_case("a_b_c"));
}