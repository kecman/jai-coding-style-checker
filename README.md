A Jai meta-program that reports violations of in-house coding standards.

Output when there are no style violations

```
matija@chip:~/dev/jai-coding-standards-demo (master)$ jai-linux build.jai
Running linker: /home/matija/Dropbox/jai//bin/lld-linux -flavor Gnu --eh-frame-hdr -export-dynamic -o main /home/matija/dev/jai-coding-standards-demo/.build/main_3_0.obj /home/matija/dev/jai-coding-standards-demo/.build/main_3_1.obj /home/matija/dev/jai-coding-standards-demo/.build/main_3_2.obj /home/matija/dev/jai-coding-standards-demo/.build/main_3_3.obj /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o -L /home/matija/dev/jai-coding-standards-demo --dynamic-linker /lib64/ld-linux-x86-64.so.2 -rpath='$ORIGIN' -L /lib -L /lib64 -L /usr/lib -L /usr/lib64 -L /usr/local/lib/x86_64-linux-gnu -L /lib/x86_64-linux-gnu -L /usr/lib/x86_64-linux-gnu -L /usr/local/cuda-10.1/targets/x86_64-linux/lib -L /usr/lib/x86_64-linux-gnu/libfakeroot -L /usr/local/lib -L /usr/lib/i686-linux-gnu -L /lib/i686-linux-gnu -L /usr/local/lib/i386-linux-gnu -L /lib/i386-linux-gnu -L /usr/lib/i386-linux-gnu -L /usr/local/lib/i686-linux-gnu -L /home/matija/Dropbox/jai/modules/ --start-group /usr/lib/x86_64-linux-gnu/libpthread.so /usr/lib/x86_64-linux-gnu/libm.so /usr/lib/x86_64-linux-gnu/libc.so /usr/lib/x86_64-linux-gnu/libdl.so /home/matija/Dropbox/jai/modules/stb_sprintf/linux/stb_sprintf.a /usr/lib/x86_64-linux-gnu/librt.so --end-group

Stats for Workspace 3, 'Target Program':
Lexer lines processed: 6143 (8089 including blank lines, comments.)
Front-end time: 0.702824 seconds.
llvm      time: 0.085562 seconds.

Compiler  time: 0.788385 seconds.
Link      time: 0.002835 seconds.
Total     time: 0.791221 seconds.
Coding style checking... PASSED
```

Output with style violations (compilation fails and all violations get reported):

```
matija@chip:~/dev/jai-coding-standards-demo (master)$ jai-linux build.jai

In workspace #2 ("Target Program"):
/home/matija/dev/jai-coding-standards-demo/main.jai:25,26: Error:
*** Coding style violation (Expected PROCEDURE_HEADER to have a lower_snake_case name) ***

    // bad_Function_Name :: () {}
    bad_fuCction_name :: () {}

/home/matija/dev/jai-coding-standards-demo/main.jai:27,8: Error:
*** Coding style violation (Using string literals in an if condition is disallowed) ***

    bad_fuCction_name :: () {}
    // bad_function_call :: () -> bool { return truth(); }
    if "hello" {}

/home/matija/dev/jai-coding-standards-demo/main.jai:28,14: Error:
*** Coding style violation (Procedure calls in if conditions are disallowed, use a local variable) ***

    // bad_function_call :: () -> bool { return truth(); }
    if "hello" {}
    if truth() {}

/home/matija/dev/jai-coding-standards-demo/main.jai:29,9: Error:
*** Coding style violation (Using more than one negation operator is disallowed) ***

    if "hello" {}
    if truth() {}
    if !!true {}

Running linker: /home/matija/Dropbox/jai//bin/lld-linux -flavor Gnu --eh-frame-hdr -export-dynamic -o main /home/matija/dev/jai-coding-standards-demo/.build/main_3_0.obj /home/matija/dev/jai-coding-standards-demo/.build/main_3_1.obj /home/matija/dev/jai-coding-standards-demo/.build/main_3_2.obj /home/matija/dev/jai-coding-standards-demo/.build/main_3_3.obj /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o -L /home/matija/dev/jai-coding-standards-demo --dynamic-linker /lib64/ld-linux-x86-64.so.2 -rpath='$ORIGIN' -L /lib -L /lib64 -L /usr/lib -L /usr/lib64 -L /usr/local/lib/x86_64-linux-gnu -L /lib/x86_64-linux-gnu -L /usr/lib/x86_64-linux-gnu -L /usr/local/cuda-10.1/targets/x86_64-linux/lib -L /usr/lib/x86_64-linux-gnu/libfakeroot -L /usr/local/lib -L /usr/lib/i686-linux-gnu -L /lib/i686-linux-gnu -L /usr/local/lib/i386-linux-gnu -L /lib/i386-linux-gnu -L /usr/lib/i386-linux-gnu -L /usr/local/lib/i686-linux-gnu -L /home/matija/Dropbox/jai/modules/ --start-group /usr/lib/x86_64-linux-gnu/libpthread.so /usr/lib/x86_64-linux-gnu/libm.so /usr/lib/x86_64-linux-gnu/libc.so /usr/lib/x86_64-linux-gnu/libdl.so /home/matija/Dropbox/jai/modules/stb_sprintf/linux/stb_sprintf.a /usr/lib/x86_64-linux-gnu/librt.so --end-group

Stats for Workspace 3, 'Target Program':
Lexer lines processed: 6147 (8089 including blank lines, comments.)
Front-end time: 0.691517 seconds.
llvm      time: 0.088279 seconds.

Compiler  time: 0.779796 seconds.
Link      time: 0.002718 seconds.
Total     time: 0.782514 seconds.
Coding style checking... FAILED with 4 errors
Error: Compilation terminated.
```