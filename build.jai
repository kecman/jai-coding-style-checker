build :: () {
    // Create a workspace for the target program.
    w := compiler_create_workspace("Target Program");
    if !w {
        print("Workspace creation failed.\n");
        return;
    }

    target_options := get_build_options(w);
    target_options.output_executable_name = "main";
    set_build_options(target_options, w);

    {
        compiler_begin_intercept(w);
        add_build_file("main.jai", w);

        while true {
            message := compiler_wait_for_message();
            if !message break;

            run_coding_style_checks(message);

            if message.kind == .COMPLETE  break;
        }

        compiler_end_intercept(w);
    }

    if num_errors_found {
        print_color("% %\n", "CloudNC coding standards checking... FAILED", tprint("with % errors", num_errors_found), color=FOREGROUND_RED);
        compiler_report("", 0, 0, "Compilation terminated.\n");
    } else {
        print_color("%\n", "CloudNC coding standards checking... PASSED", color=FOREGROUND_GREEN);
    }

    options := get_build_options();
    options.output_type = .NO_OUTPUT;
    set_build_options(options);
}

#run build();

num_errors_found := 0;

#load "coding_standards.jai";
#import "Basic";
#import "Compiler";
#import "String";
#import "Print_Color";