A Jai meta-program that reports violations of in-house coding standards.

Output when there are no style violations

```
matija@chip:~/dev/jai-coding-standards-demo (master)$ jai-linux build.jai 
Running linker: /home/matija/Dropbox/jai//bin/lld-linux -flavor Gnu --eh-frame-hdr -export-dynamic -o target /home/matija/dev/jai-coding-standards-demo/.build/target_3_0.obj /home/matija/dev/jai-coding-standards-demo/.build/target_3_1.obj /home/matija/dev/jai-coding-standards-demo/.build/target_3_2.obj /home/matija/dev/jai-coding-standards-demo/.build/target_3_3.obj /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o -L /home/matija/dev/jai-coding-standards-demo --dynamic-linker /lib64/ld-linux-x86-64.so.2 -rpath='$ORIGIN' -L /lib -L /lib64 -L /usr/lib -L /usr/lib64 -L /usr/local/lib/x86_64-linux-gnu -L /lib/x86_64-linux-gnu -L /usr/lib/x86_64-linux-gnu -L /usr/local/cuda-10.1/targets/x86_64-linux/lib -L /usr/lib/x86_64-linux-gnu/libfakeroot -L /usr/local/lib -L /usr/lib/i686-linux-gnu -L /lib/i686-linux-gnu -L /usr/local/lib/i386-linux-gnu -L /lib/i386-linux-gnu -L /usr/lib/i386-linux-gnu -L /usr/local/lib/i686-linux-gnu -L /home/matija/Dropbox/jai/modules/ --start-group /usr/lib/x86_64-linux-gnu/libpthread.so /usr/lib/x86_64-linux-gnu/libm.so /usr/lib/x86_64-linux-gnu/libc.so /usr/lib/x86_64-linux-gnu/libdl.so /home/matija/Dropbox/jai/modules/stb_sprintf/linux/stb_sprintf.a /usr/lib/x86_64-linux-gnu/librt.so --end-group

Stats for Workspace 3, 'Target Program':
Lexer lines processed: 6153 (8114 including blank lines, comments.)
Front-end time: 0.669836 seconds.
llvm      time: 0.091203 seconds.

Compiler  time: 0.761039 seconds.
Link      time: 0.002718 seconds.
Total     time: 0.763757 seconds.
CloudNC coding standards checking... PASSED
```

Output with style violations (compilation fails and all violations get reported):

```
matija@chip:~/dev/jai-coding-standards-demo (master)$ jai-linux build.jai 

In workspace #2 ("Target Program"):
/home/matija/dev/jai-coding-standards-demo/main.jai:29,9: Error: 
*** CloudNC coding style violation (Procedure calls in returns are not allowed) ***

    bad_function_call :: () -> bool {
        return truth();

/home/matija/dev/jai-coding-standards-demo/main.jai:31,7: Error: 
*** CloudNC coding style violation (Procedure calls are not allowed in if conditions, assign to a local variable) ***

        return truth();
    }
    if truth() {}

/home/matija/dev/jai-coding-standards-demo/main.jai:32,7: Error: 
*** CloudNC coding style violation (Why are you using more than one negation in an if condition??) ***

    }
    if truth() {}
    if !!true {}

/home/matija/dev/jai-coding-standards-demo/main.jai:33,7: Error: 
*** CloudNC coding style violation (Exceeded maximum binary operator count (3) in if condition) ***

    if truth() {}
    if !!true {}
    if true != true || true == true && truth() {}

Running linker: /home/matija/Dropbox/jai//bin/lld-linux -flavor Gnu --eh-frame-hdr -export-dynamic -o main /home/matija/dev/jai-coding-standards-demo/.build/main_3_0.obj /home/matija/dev/jai-coding-standards-demo/.build/main_3_1.obj /home/matija/dev/jai-coding-standards-demo/.build/main_3_2.obj /home/matija/dev/jai-coding-standards-demo/.build/main_3_3.obj /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o -L /home/matija/dev/jai-coding-standards-demo --dynamic-linker /lib64/ld-linux-x86-64.so.2 -rpath='$ORIGIN' -L /lib -L /lib64 -L /usr/lib -L /usr/lib64 -L /usr/local/lib/x86_64-linux-gnu -L /lib/x86_64-linux-gnu -L /usr/lib/x86_64-linux-gnu -L /usr/local/cuda-10.1/targets/x86_64-linux/lib -L /usr/lib/x86_64-linux-gnu/libfakeroot -L /usr/local/lib -L /usr/lib/i686-linux-gnu -L /lib/i686-linux-gnu -L /usr/local/lib/i386-linux-gnu -L /lib/i386-linux-gnu -L /usr/lib/i386-linux-gnu -L /usr/local/lib/i686-linux-gnu -L /home/matija/Dropbox/jai/modules/ --start-group /usr/lib/x86_64-linux-gnu/libpthread.so /usr/lib/x86_64-linux-gnu/libm.so /usr/lib/x86_64-linux-gnu/libc.so /usr/lib/x86_64-linux-gnu/libdl.so /home/matija/Dropbox/jai/modules/stb_sprintf/linux/stb_sprintf.a /usr/lib/x86_64-linux-gnu/librt.so --end-group

Stats for Workspace 3, 'Target Program':
Lexer lines processed: 6151 (8084 including blank lines, comments.)
Front-end time: 0.704548 seconds.
llvm      time: 0.091416 seconds.

Compiler  time: 0.795964 seconds.
Link      time: 0.002798 seconds.
Total     time: 0.798762 seconds.
CloudNC coding standards checking... FAILED with 4 errors
Error: Compilation terminated.
```