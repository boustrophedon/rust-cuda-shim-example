This is a complete example of a cargo package that allows you to link C functions that call out to CUDA functions into your Rust program. The c/cuda program itself just implements min via a linear search in C and via a pairing-based "log" search in CUDA. It's only O(logn) if you can run enough (i.e. a constant fraction) of the comparisons in parallel though, and my implementation just breaks if you have too much data rather than splitting it up into batches and merging, and the linear search is faster in most cases (less than like 10 million or something) simply because of driver overhead.

Things to note:
- build.rs allows us to do the linking. Some of it could also be done in the Cargo.toml but I thought it would be easier to put it all in the build.rs.
- To build the C/CUDA code we just run a simple makefile.
	- The only thing special about that makefile is the -Xcompiler flag before -fPIC, which just tells nvcc to pass -fPIC to the compiler.
	- The CUDA-kernel-running C headers are wrapped in an extern C ifdef because nvcc is a C++ compiler, so it would mangle the names otherwise.
- The rust code is very simple.
	- The external C functions are declared in the extern at the top of the main.rs.

Problems:
- There isn't a corresponding clean.rs so I can't just run make clean
	- I considered a few things like copying the entire directory over, or running in-folder and then copying to OUT\_DIR, but I really didn't want to write any object files or move any files inside the source directories, so the makefile is a bit ugly with $(OBJDIR) everywhere and what I consider to be over-use of the $< $@ $^ magic make variables.
- It's annoying that I have to check if the previous output directory is still around so that the build.rs doesn't panic when I try to create one for the liblogmin.a file.

Sources used:

http://doc.crates.io/build-script.html  
https://doc.rust-lang.org/book/ffi.html  


and here's a sampling of some stack overflow questions that may help to figure out how to link everything together properly, because linkers are evil nefarious beasts:

http://stackoverflow.com/questions/13553015/cuda-c-linker-error-undefined-reference  
http://stackoverflow.com/questions/4307053/cuda-cudpp-so-building  
http://stackoverflow.com/questions/6045809/problem-with-g-and-undefined-reference-to-gxx-personality-v0  
http://stackoverflow.com/questions/28060294/linking-to-a-c-library-that-has-extern-c-functions  
