/++
 + D interface to the Boehm-Demers-Weiser Garbage Collector (BDWGC).
 + Provides a structured allocator API for GC-managed memory with thread support.
 +
 + Note: All allocations, including aligned ones, are GC-managed via BDWGC.
 + Thread registration is required for multi-threaded applications when GCThreads is enabled.
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

public import c.gc;
import std.algorithm.comparison : max;

// Declare missing BDWGC thread functions
version (GCThreads)
{
extern (C) @nogc nothrow:
    int GC_thread_is_registered(); // Returns non-zero if thread is registered
    void GC_register_my_thread(); // Registers the current thread
    void GC_unregister_my_thread(); // Unregisters the current thread
    version (Posix) void GC_allow_register_threads(); // Enables dynamic thread registration
}

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
 + Manage BDWGC thread registration.
 + Use ThreadGuard.create() to instantiate and register the current thread.
 + Unregisters the thread on destruction. No-op if GCThreads is disabled.
 +/
struct ThreadGuard
{
@nogc nothrow:
    this(this) @disable; // Prevent copying
    private bool isRegistered; // Track registration state

    /// Factory function to create and register a ThreadGuard
    @trusted static ThreadGuard create()
    {
        ThreadGuard guard;
        version (GCThreads)
        {
            if (!GC_thread_is_registered())
            {
                version (unittest)
                    GC_printf("Registering thread\n");
                GC_register_my_thread();
                guard.isRegistered = true;
            }
        }
        return guard;
    }

    /// Unregisters the thread if registered
    @trusted ~this()
    {
        version (GCThreads)
        {
            if (isRegistered && GC_thread_is_registered())
            {
                version (unittest)
                    GC_printf("Unregistering thread\n");
                GC_unregister_my_thread();
            }
        }
    }
}

/++
 + Allocator for BDWGC-managed memory.
 + Thread-safe and compatible with `-betterC`.
 + Requires thread registration for multi-threaded use when GCThreads is enabled.
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

    /// One-time initialization of BDWGC with thread support
    shared static this() @nogc nothrow
    {
        version (unittest)
            GC_printf("Initializing BDWGC\n");
        GC_init();
        version (GCThreads)
        {
            // Enable thread support
            version (Posix)
                GC_allow_register_threads();
        }
    }

    /// Allocates memory of specified size, returns null if allocation fails
    @trusted @nogc nothrow
    void[] allocate(size_t bytes) shared const
    {
        if (!bytes)
            return null;
        auto p = GC_MALLOC(bytes);
        return p ? p[0 .. bytes] : null;
    }

    /// Allocates aligned memory using GC_memalign, returns null if allocation fails
    @trusted @nogc nothrow
    void[] alignedAllocate(size_t bytes, uint a) shared const
    {
        if (!bytes || !a.isGoodDynamicAlignment)
            return null;
        auto p = GC_memalign(a, bytes);
        return p ? p[0 .. bytes] : null;
    }

    /// Deallocates memory, safe for null buffers
    @system @nogc nothrow
    bool deallocate(void[] b) shared const
    {
        if (b.ptr)
            GC_FREE(b.ptr);
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
        auto p = GC_REALLOC(b.ptr, newSize);
        if (!p)
            return false;
        b = p[0 .. newSize];
        return true;
    }

    /// Allocates zero-initialized memory
    @trusted @nogc nothrow
    void[] allocateZeroed(size_t bytes) shared const
    {
        if (!bytes)
            return null;
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
        GC_enable_incremental();
    }

    /// Disables garbage collection
    @trusted @nogc nothrow
    void disable() shared
    {
        GC_disable();
    }

    /// Triggers garbage collection
    @trusted @nogc nothrow
    void collect() shared
    {
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

version (unittest)
{
    @("Basic allocation and deallocation")
    @nogc @system nothrow unittest
    {
        auto guard = ThreadGuard.create();
        auto buffer = GCAllocator.instance.allocate(1024 * 1024 * 4);
        scope (exit)
            GCAllocator.instance.deallocate(buffer);
        assert(buffer !is null);
        assert(GCAllocator.instance.isHeapPtr(buffer.ptr));
    }

    @("Aligned allocation")
    @nogc @system nothrow unittest
    {
        auto guard = ThreadGuard.create();
        auto buffer = GCAllocator.instance.alignedAllocate(1024, 128);
        scope (exit)
            GCAllocator.instance.deallocate(buffer);
        assert(buffer !is null);
        assert((cast(size_t) buffer.ptr) % 128 == 0);
    }

    @("Reallocation and zeroed allocation")
    @nogc @system nothrow unittest
    {
        auto guard = ThreadGuard.create();
        void[] b = GCAllocator.instance.allocate(16);
        assert(b !is null, "Allocation failed");
        (cast(ubyte[]) b)[] = ubyte(1);
        // Debug: Print buffer contents before reallocation
        version (unittest)
        {
            GC_printf("Before realloc: ");
            foreach (i; 0 .. 16)
                GC_printf("%02x ", (cast(ubyte[]) b)[i]);
            GC_printf("\n");
        }
        assert(GCAllocator.instance.reallocate(b, 32), "Reallocation failed");
        // Debug: Print buffer contents after reallocation
        version (unittest)
        {
            GC_printf("After realloc: ");
            foreach (i; 0 .. 16)
                GC_printf("%02x ", (cast(ubyte[]) b)[i]);
            GC_printf("\n");
        }
        ubyte[16] expected = 1;
        // Manual comparison to avoid issues
        bool isEqual = true;
        for (size_t i = 0; i < 16; i++)
            if ((cast(ubyte[]) b)[i] != 1)
            {
                isEqual = false;
                break;
            }
        assert(isEqual, "Reallocated buffer contents incorrect");
        GCAllocator.instance.deallocate(b);

        auto zeroed = GCAllocator.instance.allocateZeroed(16);
        assert(zeroed !is null, "Zeroed allocation failed");
        ubyte[16] zeroExpected = 0;
        assert((cast(ubyte[]) zeroed)[] == zeroExpected, "Zeroed buffer not zero");
        GCAllocator.instance.deallocate(zeroed);
    }

    @("Incremental GC and collection")
    @nogc @system nothrow unittest
    {
        auto guard = ThreadGuard.create();
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
        auto guard = ThreadGuard.create();
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

    @("Thread registration")
    @nogc @system nothrow unittest
    {
        version (GCThreads)
        {
            assert(!GC_thread_is_registered());
            {
                auto guard = ThreadGuard.create();
                assert(GC_thread_is_registered());
                auto buffer = GCAllocator.instance.allocate(1024);
                assert(buffer !is null);
                GCAllocator.instance.deallocate(buffer);
            }
            assert(!GC_thread_is_registered());
        }
        else
        {
            auto guard = ThreadGuard.create();
            auto buffer = GCAllocator.instance.allocate(1024);
            assert(buffer !is null);
            GCAllocator.instance.deallocate(buffer);
        }
    }

    @("Aligned allocation (cross-platform)")
    @nogc @system nothrow unittest
    {
        auto guard = ThreadGuard.create();
        void[] b = GCAllocator.instance.alignedAllocate(16, 32);
        (cast(ubyte[]) b)[] = ubyte(1);
        ubyte[16] expected = 1;
        assert((cast(ubyte[]) b)[] == expected);
        GCAllocator.instance.deallocate(b);
    }
}
