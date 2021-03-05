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
        }
    }
}

report_cloudnc_error :: (node: *Code_Node, description: string) {
    error := sprint("\n*** CloudNC coding style violation (%) ***", description);
    defer free(error.data);
    compiler_report(error, make_location(node), .ERROR_CONTINUABLE);
    num_errors_found += 1;
}

#scope_file

//
// Check return statements
//

style_check_return :: (node : *Code_Return) {
    for arg : node.arguments_unsorted {
        if arg.expression.kind == .PROCEDURE_CALL {
            report_cloudnc_error(node, "Procedure call in return value");
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
                return "Exceeded maximum binary operator count (4) in if condition", node; 
            }

            lhs_reason, lhs_error := style_check_if_condition(op.left);
            if lhs_reason != "" {
                return lhs_reason, lhs_error;
            }

            rhs_reason, rhs_error := style_check_if_condition(op.right);
            if rhs_reason != "" {
                return rhs_reason, rhs_error;
            }

        case .PROCEDURE_CALL;
            return "Procedure calls are not allowed in if conditions, assign to a local variable", node;
    }

    return "", null;
}

print_exp :: (node : *Code_Node) {
    builder: String_Builder;
    defer free_buffers(*builder);
    print_expression(*builder, node);
    print("print_expression: %, %\n", node.kind, builder_to_string(*builder));
}