cloudnc_style_checks :: (message: *Message) {
    if message.kind != .TYPECHECKED return;

    code := cast(*Message_Typechecked) message;

    for decl: code.declarations {
        if !contains(decl.filename, "main") continue;

        for decl.expressions {
            if it.kind == .IF {
                style_check_if(xx it);
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
                    report_cloudnc_error(root_expression, reason);
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
                report_cloudnc_error(ident, reason);
            }

        case .STRUCT; #through;
        case .ENUM;   #through;
        case .TYPE;
            if !is_upper_snake_case(ident.name) {
                reason := tprint("Expected % to have a Upper_Snake_Case name", type_info_tag);
                report_cloudnc_error(ident, reason);
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
            report_cloudnc_error(node, "Procedure calls in returns are not allowed");
        }
    }
}

//
// Check if statements
//

if_condition_binary_operator_count := 0;
if_condition_unary_negation_operator_count := 0;

style_check_if :: (node : *Code_If) {
    if_condition_binary_operator_count = 0;
    if_condition_unary_negation_operator_count = 0;
    reason, error := style_check_if_condition(node.condition);
    if reason != "" {
         report_cloudnc_error(xx node, reason);
    }
}

style_check_if_condition :: (node : *Code_Node) -> (reason : string, error_node : *Code_Node)
{
    if node.kind ==
    {
        case .CAST;
            // We get a cast node in cases like `if 42 {}` and `if "hi" {}`
            cast_ := cast(*Code_Cast) node;
            reason, error := style_check_if_condition(cast_.expression);
            if reason != "" {
                return reason, error;
            }

        case .LITERAL;
            literal := cast(*Code_Literal) node;
            if literal.value_type == .STRING {
                return "Using string literals in an if condition is disallowed", node;
            }

        case .UNARY_OPERATOR;
            op := cast(*Code_Unary_Operator) node;
            token := cast(Operator_Type)op.operator_type;

            if token == xx #char "!" {
                if_condition_unary_negation_operator_count += 1;
                if if_condition_unary_negation_operator_count > 1 {
                    return "Why are you using more than one negation in an if condition??", node;
                }
            }

            reason, error := style_check_if_condition(op.subexpression);
            if reason != "" {
                return reason, error;
            }

        case .BINARY_OPERATOR;
            op := cast(*Code_Binary_Operator) node;

            if_condition_binary_operator_count += 1;
            if if_condition_binary_operator_count >= 4 {
                // This restriction is a probably not a good idea...
                return "Exceeded maximum binary operator count (3) in if condition", node;
            }

            if_condition_unary_negation_operator_count = 0; // Reset negation counter before checking subexpression
            lhs_reason, lhs_error := style_check_if_condition(op.left);
            if lhs_reason != "" {
                return lhs_reason, lhs_error;
            }

            if_condition_unary_negation_operator_count = 0; // Reset negation counter before checking subexpression
            rhs_reason, rhs_error := style_check_if_condition(op.right);
            if rhs_reason != "" {
                return rhs_reason, rhs_error;
            }

        case .PROCEDURE_CALL;
            return "Procedure calls are not allowed in if conditions, use a local variable", node;

        case .IDENT;
            // Identifier styles are checked when declarations are checked
    }

    return "", null;
}

report_cloudnc_error :: (node: *Code_Node, description: string) {
    error := sprint("\n*** CloudNC coding style violation (%) ***", description);
    defer free(error.data);
    compiler_report(error, make_location(node), .ERROR_CONTINUABLE);
    num_errors_found += 1;
}


#load "utils.jai";
#import "String";