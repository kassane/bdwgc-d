# bdwgc-d

D library for interfacing with libgc (bdwgc) using [`importC`](https://dlang.org/spec/importc.html)


### Required

- [zig](https://ziglang.org/download) v0.12.0 or master
- [ldc](https://ldc-developers.github.io) v1.36.0 or latest-CI (nightly)

### How to use (zig build)

```bash
$ zig build -h
Project-Specific Options:
  -Dtarget=[string]            The CPU architecture, OS, and ABI to build for
  -Dcpu=[string]               Target CPU features to add or subtract
  -Ddynamic-linker=[string]    Path to interpreter on the target system
  -Doptimize=[enum]            Prioritize performance, safety, or binary size
                                 Supported Values:
                                   Debug
                                   ReleaseSafe
                                   ReleaseFast
                                   ReleaseSmall
  -Denable_cplusplus=[bool]    C++ support
  -DBUILD_SHARED_LIBS=[bool]   Build shared libraries (otherwise static ones)
  -DCFLAGS_EXTRA=[string]      Extra user-defined cflags
  -Denable_parallel_mark=[bool] Parallelize marking and free list construction
  -Denable_threads=[bool]      Support threads
  -Denable_thread_local_alloc=[bool] Turn on thread-local allocation optimization
  -Denable_threads_discovery=[bool] Enable threads discovery in GC
  -Denable_rwlock=[bool]       Enable reader mode of the allocator lock
  -Denable_throw_bad_alloc_library=[bool] Turn on C++ gctba library build
  -Denable_gcj_support=[bool]  Support for gcj
  -Denable_sigrt_signals=[bool] Use SIGRTMIN-based signals for thread suspend/resume
  -Denable_valgrind_tracking=[bool] Support tracking GC_malloc and friends for heap profiling tools
  -Denable_java_finalization=[bool] Support for java finalization
  -Denable_atomic_uncollectable=[bool] Support for atomic uncollectible allocation
  -Denable_gc_debug=[bool]     Support for pointer back-tracing
  -Denable_redirect_malloc=[bool] Redirect malloc and friend to GC routines
  -Denable_disclaim=[bool]     Support alternative finalization interface
  -Denable_dynamic_pointer_mask=[bool] Support pointer mask/shift set at runtime
  -Denable_large_config=[bool] Optimize for large heap or root set
  -Denable_gc_assertions=[bool] Enable collector-internal assertion checking
  -Denable_mmap=[bool]         Use mmap instead of sbrk to expand the heap
  -Denable_munmap=[bool]       Return page to the OS if empty for N collections
  -Denable_dynamic_loading=[bool] Enable tracing of dynamic library data roots
  -Denable_register_main_static_data=[bool] Perform the initial guess of data root sets
  -Denable_checksums=[bool]    Report erroneously cleared dirty bits
  -Denable_werror=[bool]       Pass -Werror to the C compiler (treat warnings as errors)
  -Denable_single_obj_compilation=[bool] Compile all libgc source files into single .o
  -Ddisable_single_obj_compilation=[bool] Compile each libgc source file independently
  -Denable_handle_fork=[bool]  Attempt to ensure a usable collector after fork()
  -Ddisable_handle_fork=[bool] Prohibit installation of pthread_atfork() handlers
  -Dartifact_dub=[bool]        Available artifacts to DUB
  -Dbuild_examples=[bool]      Build Examples
```

### Compiler Support

`bdwgc-d` should be compatible with multiple D compilers including `gdc`, `ldc2`, and `dmd`. When you use `dub` to build your project, it should automatically detect the compiler you have installed and use it to compile your code.