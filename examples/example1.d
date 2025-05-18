/++
 + Example using the BDWGC allocator to allocate and reallocate memory,
 + printing heap size periodically.
 +/
import bdwgc;

enum max = 10_000_000;

extern (C) @trusted @nogc nothrow
void main()
{
    foreach (i; 0 .. max)
    {
        // Allocate pointer-sized memory for p (zero-initialized, like GC_MALLOC_ATOMIC)
        void[] pBuf = GCAllocator.instance.allocateZeroed(size_t.sizeof);
        if (!pBuf.ptr)
        {
            version (unittest)
                GC_printf("Failed to allocate p at iteration %ld\n", i);
            break;
        }
        auto p = cast(int**) pBuf.ptr;

        // Allocate pointer-sized memory for q
        void[] qBuf = GCAllocator.instance.allocate(size_t.sizeof);
        if (!qBuf.ptr)
        {
            version (unittest)
                GC_printf("Failed to allocate q at iteration %ld\n", i);
            GCAllocator.instance.deallocate(pBuf);
            break;
        }

        // Reallocate q to twice the size and assign to *p
        if (!GCAllocator.instance.reallocate(qBuf, size_t.sizeof * 2))
        {
            version (unittest)
                GC_printf("Failed to reallocate q at iteration %ld\n", i);
            GCAllocator.instance.deallocate(pBuf);
            GCAllocator.instance.deallocate(qBuf);
            break;
        }
        *p = cast(int*) qBuf.ptr;

        // Periodically print heap size
        if (i % 100_000 == 0)
        {
            const heap = GC_get_heap_size();
            version (Windows)
            {
                GC_printf("heap size: %u\n", cast(uint) heap);
            }
            else
            {
                GC_printf("heap size: %ld\n", heap);
            }
        }

        // Deallocate buffers (optional, as BDWGC will collect, but explicit for safety)
        GCAllocator.instance.deallocate(pBuf);
        GCAllocator.instance.deallocate(qBuf);
    }
}
