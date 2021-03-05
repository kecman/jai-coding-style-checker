cloudnc_style_checks :: (message: *Message) {
    if message.kind != .TYPECHECKED return;

    code := cast(*Message_Typechecked) message;
    
    for decl: code.declarations {
        if !contains(decl.filename, "main") continue;

        for decl.expressions {
            // Run the if statement checks
            if it.kind == .IF {
                style_check_if(xx it);
            }

            // Run the return statement checks
            if it.kind == .RETURN {
                style_check_return(xx it);
            }
        }
    }
}

#scope_file

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
    if reason != "" report_cloudnc_error(xx node, reason);
}

style_check_if_condition :: (node : *Code_Node) -> (reason : string, error_node : *Code_Node)
{
    if node.kind ==
    {
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
            return "Procedure calls are not allowed in if conditions, assign to a local variable", node;
    }

    return "", null;
}

report_cloudnc_error :: (node: *Code_Node, description: string) {
    error := sprint("\n*** CloudNC coding style violation (%) ***", description);
    defer free(error.data);
    compiler_report(error, make_location(node), .ERROR_CONTINUABLE);
    num_errors_found += 1;
}