/++
 + D interface to the Boehm-Demers-Weiser Garbage Collector (BDWGC).
 + Provides a structured allocator API for GC-managed memory.
 +
 + Note: `alignedAllocate` uses platform-specific allocation (not GC-managed),
 + so deallocated memory must be handled carefully to avoid using `GC_FREE` on
 + non-GC memory.
 +/
module bdwgc;

version (D_BetterC)
{
    version (LDC)
    {
        pragma(LDC_no_moduleinfo);
        pragma(LDC_no_typeinfo);
    }
}

/// BDWGC C bindings
public import c.gc; // @system
import std.algorithm.comparison : max;

/++
 + Checks if alignment is valid: a power of 2 and at least pointer size.
 +/
bool isGoodDynamicAlignment(uint x) @nogc nothrow pure
{
    return x >= (void*).sizeof && (x & (x - 1)) == 0;
}

version (Windows)
{
    private import core.stdc.stdio : printf;

    alias GC_printf = printf; /// Alias for Windows printf
}
else
{
    /// Formatted output for GC logging
    pragma(printf)
    extern (C) void GC_printf(const(char)* format, ...) @trusted @nogc nothrow;
}

/++
 + Allocator for BDWGC-managed memory.
 + Thread-safe and compatible with `-betterC`.
 +/
struct GCAllocator
{
    version (StdUnittest) @system unittest
    {
        extern (C) void testAllocator(alias alloc)(); // Declare testAllocator
        testAllocator!(() => GCAllocator.instance)();
    }

    /// Alignment ensures proper alignment for D data types
    enum uint platformAlignment = max(double.alignof, real.alignof);

    /// Initializes the garbage collector, idempotent
    @trusted @nogc nothrow
    void initialize() shared const
    {
        import core.stdc.stdlib : getenv;

        if (getenv("GC_INITIALIZED") is null)
        {
            version (unittest)
                GC_printf("Initializing BDWGC\n");
            GC_init();
        }
    }

    /// Allocates memory of specified size, returns null if allocation fails
    @trusted @nogc nothrow
    void[] allocate(size_t bytes) shared const
    {
        if (!bytes)
            return null;
        initialize();
        auto p = GC_MALLOC(bytes);
        return p ? p[0 .. bytes] : null;
    }

    /// Allocates aligned memory, returns null if allocation fails
    version (Posix)
        @trusted @nogc nothrow
        void[] alignedAllocate(size_t bytes, uint a) shared
    {
        import core.stdc.errno : ENOMEM, EINVAL;
        import core.sys.posix.stdlib : posix_memalign;

        if (!bytes || !a.isGoodDynamicAlignment)
            return null;
        initialize();
        void* result;
        auto code = posix_memalign(&result, a, bytes);
        version (LDC_AddressSanitizer)
        {
            if (code == -1)
                return null;
        }
        if (code == ENOMEM || code == EINVAL || code != 0)
            return null;
        return result[0 .. bytes];
    }
    else version (Windows)
        @trusted @nogc nothrow
        void[] alignedAllocate(size_t bytes, uint a) shared
    {
        import core.stdc.stdlib : _aligned_malloc;

        if (!bytes || !a.isGoodDynamicAlignment)
            return null;
        initialize();
        auto p = _aligned_malloc(bytes, a);
        return p ? p[0 .. bytes] : null;
    }
    else
        static assert(0, "Aligned allocation not supported");

    /// Deallocates memory, safe for null buffers
    @system @nogc nothrow
    bool deallocate(void[] b) shared const
    {
        if (!b.ptr)
            return true;
        if (isHeapPtr(b.ptr))
            GC_FREE(b.ptr);
        else version (Posix)
        {
            import core.stdc.stdlib : free;

            free(b.ptr);
        }
        else version (Windows)
        {
            import core.stdc.stdlib : _aligned_free;

            _aligned_free(b.ptr);
        }
        return true;
    }

    /// Reallocates memory to new size, handles zero-size deallocation
    @system @nogc nothrow
    bool reallocate(ref void[] b, size_t newSize) shared const
    {
        if (!newSize)
        {
            deallocate(b);
            b = null;
            return true;
        }
        if (!b.ptr || isHeapPtr(b.ptr))
        {
            auto p = GC_REALLOC(b.ptr, newSize);
            if (!p)
                return false;
            b = p[0 .. newSize];
            return true;
        }
        return false; // Cannot reallocate non-GC memory
    }

    /// Allocates zero-initialized memory
    @trusted @nogc nothrow
    void[] allocateZeroed(size_t bytes) shared const
    {
        if (!bytes)
            return null;
        initialize();
        auto p = GC_MALLOC_ATOMIC(bytes);
        if (!p)
            return null;
        import core.stdc.string : memset;

        memset(p, 0, bytes);
        return p[0 .. bytes];
    }

    /// Enables incremental garbage collection
    @trusted @nogc nothrow
    void enableIncremental() shared
    {
        initialize();
        GC_enable_incremental();
    }

    /// Disables garbage collection
    @trusted @nogc nothrow
    void disable() shared
    {
        initialize();
        GC_disable();
    }

    /// Triggers garbage collection
    @trusted @nogc nothrow
    void collect() shared
    {
        initialize();
        GC_gcollect();
    }

    /// Checks if pointer is GC-managed
    @trusted @nogc nothrow
    bool isHeapPtr(const void* ptr) shared const
    {
        return GC_is_heap_ptr(cast(void*) ptr) != 0;
    }

    /// Global thread-safe instance
    static shared GCAllocator instance;
}

version (CRuntime_Microsoft)
{
    @nogc nothrow pure private extern (C) void* _aligned_malloc(size_t, size_t);
    @nogc nothrow pure private extern (C) void _aligned_free(void* memblock);
    @nogc nothrow pure private extern (C) void* _aligned_realloc(void*, size_t, size_t);
}

version (unittest)
{
    @("Basic allocation and deallocation")
    @nogc @system nothrow unittest
    {
        auto buffer = GCAllocator.instance.allocate(1024 * 1024 * 4);
        scope (exit)
            GCAllocator.instance.deallocate(buffer);
        assert(buffer !is null);
        assert(GCAllocator.instance.isHeapPtr(buffer.ptr));
    }

    @("Aligned allocation")
    @nogc @system nothrow unittest
    {
        auto buffer = GCAllocator.instance.alignedAllocate(1024, 128);
        scope (exit)
            GCAllocator.instance.deallocate(buffer);
        assert(buffer !is null);
        assert((cast(size_t) buffer.ptr) % 128 == 0);
    }

    @("Reallocation and zeroed allocation")
    @nogc @system nothrow unittest
    {
        void[] b = GCAllocator.instance.allocate(16);
        (cast(ubyte[]) b)[] = ubyte(1);
        assert(GCAllocator.instance.reallocate(b, 32));
        ubyte[16] expected = 1;
        assert((cast(ubyte[]) b)[0 .. 16] == expected);
        GCAllocator.instance.deallocate(b);
    }

    @("Incremental GC and collection")
    @nogc @system nothrow unittest
    {
        GCAllocator.instance.enableIncremental();
        auto b = GCAllocator.instance.allocate(1024);
        assert(b !is null);
        GCAllocator.instance.collect();
        GCAllocator.instance.disable();
        GCAllocator.instance.deallocate(b);
    }

    @("Allocator interface compliance")
    @nogc @system nothrow unittest
    {
        static void test(A)()
        {
            int* p = cast(int*) A.instance.allocate(int.sizeof);
            scope (exit)
                A.instance.deallocate(p[0 .. int.sizeof]);
            *p = 42;
            assert(*p == 42);
        }

        test!GCAllocator();
    }

    version (Posix) @("Posix aligned allocation")
    @nogc @system nothrow unittest
    {
        void[] b = GCAllocator.instance.alignedAllocate(16, 32);
        (cast(ubyte[]) b)[] = ubyte(1);
        ubyte[16] expected = 1;
        assert((cast(ubyte[]) b)[0 .. 16] == expected);
        GCAllocator.instance.deallocate(b);
    }
}
