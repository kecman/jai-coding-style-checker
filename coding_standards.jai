run_coding_style_checks :: (message: *Message) {
    if message.kind != .TYPECHECKED return;

    code := cast(*Message_Typechecked) message;

    for decl: code.declarations {
        if !contains(decl.filename, "main") continue;

        for decl.expressions {
            if it.kind == .IF {
                if_condition_binary_operator_count = 0;
                if_condition_unary_negation_operator_count = 0;
                if_ := cast(*Code_If) it;
                style_check_if_condition(if_.condition);
            }

            if it.kind == .RETURN {
                style_check_return(xx it);
            }

            if it.kind == .DECLARATION {
                style_check_declaration(xx it);
            }
        }
    }
}

#scope_file

style_check_declaration :: (decl : *Code_Declaration)
{
    root_expression : *Code_Node = decl.root_expression;

    if root_expression {
        if root_expression.kind == {
            case .PROCEDURE_HEADER;
                header := cast(*Code_Procedure_Header) root_expression;
                if !is_lower_snake_case(header.name) {
                    reason := tprint("Expected % to have a lower_snake_case name", root_expression.kind);
                    report_coding_style_error(root_expression, reason);
                }
            case .IDENT;
                style_check_identifier(xx root_expression);
        }
    }
}

style_check_identifier :: (ident : *Code_Ident)
{
    resolved_declaration : *Code_Declaration = ident.resolved_declaration;

    assert(resolved_declaration != null, "Expected a resolved declaration");
    root_expression : *Code_Node = ident.resolved_declaration.root_expression;

    assert(root_expression != null, "Expected a root expression");
    type_info_tag := root_expression.type.type;

    if #complete type_info_tag == {
        case .INTEGER;              #through;
        case .FLOAT;                #through;
        case .BOOL;                 #through;
        case .STRING;               #through;
        case .POINTER;              #through;
        case .ARRAY;                #through;
        case .POLYMORPHIC_VARIABLE; #through;
        case .ANY;                  #through;
        case .PROCEDURE;
            if !is_lower_snake_case(ident.name) {
                reason := tprint("Expected % to have a lower_snake_case name", type_info_tag);
                report_coding_style_error(ident, reason);
            }

        case .STRUCT; #through;
        case .ENUM;   #through;
        case .TYPE;
            if !is_upper_snake_case(ident.name) {
                reason := tprint("Expected % to have a Upper_Snake_Case name", type_info_tag);
                report_coding_style_error(ident, reason);
            }

        case .VOID;
        case .OVERLOAD_SET;
        case .CODE;
    }
}

//
// Check return statements
//

style_check_return :: (node : *Code_Return) {
    for arg : node.arguments_unsorted {
        if arg.expression.kind == .PROCEDURE_CALL {
            report_coding_style_error(node, "Procedure calls in returns are not allowed");
        }
    }
}

//
// Check if statements
//

if_condition_binary_operator_count := 0;
if_condition_unary_negation_operator_count := 0;

style_check_if_condition :: (node : *Code_Node)
{
    if node.kind ==
    {
        case .CAST;
            // We get a cast node in cases like `if 42 {}` and `if "hi" {}`
            cast_ := cast(*Code_Cast) node;
            style_check_if_condition(cast_.expression);

        case .LITERAL;
            literal := cast(*Code_Literal) node;
            if literal.value_type == .STRING {
                report_coding_style_error(node, "Using string literals in an if condition is disallowed");
            }

        case .UNARY_OPERATOR;
            op := cast(*Code_Unary_Operator) node;
            token := cast(Operator_Type)op.operator_type;

            if token == xx #char "!" {
                if_condition_unary_negation_operator_count += 1;
                if if_condition_unary_negation_operator_count > 1 {
                    report_coding_style_error(node, "Using more than one negation operator is disallowed");
                }
            }

            style_check_if_condition(op.subexpression);

        case .BINARY_OPERATOR;
            op := cast(*Code_Binary_Operator) node;

            if_condition_binary_operator_count += 1;
            if if_condition_binary_operator_count >= 4 {
                // This restriction is a probably not a good idea...
                report_coding_style_error(node, "Exceeded maximum binary operator count (3) in if condition");
            }

            // Reset negation counter before checking subexpression
            if_condition_unary_negation_operator_count = 0;
            style_check_if_condition(op.left);

            // Reset negation counter before checking subexpression
            if_condition_unary_negation_operator_count = 0;
            style_check_if_condition(op.right);

        case .PROCEDURE_CALL;
            report_coding_style_error(node, "Procedure calls in if conditions are disallowed, use a local variable");
    }
}

report_coding_style_error :: (node: *Code_Node, description: string) {
    error := sprint("\n*** CloudNC coding style violation (%) ***", description);
    defer free(error.data);
    compiler_report(error, make_location(node), .ERROR_CONTINUABLE);
    num_errors_found += 1;
}


#load "utils.jai";
#import "String";