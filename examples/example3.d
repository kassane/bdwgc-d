/++
 + Example using the BDWGC allocator in a threaded context to allocate,
 + populate, and print an array of integers.
 +/
import bdwgc;
import core.thread;

void main() @trusted
{
    // Enable leak detection and incremental GC
    GC_set_find_leak(1);
    GCAllocator.instance.enableIncremental();
    GC_start_incremental_collection();

    // Thread registration for main thread (no-op if GCThreads is disabled)
    auto mainGuard = ThreadGuard.create();

    version (OSX)
    {
        // OSX: Run in main thread due to threading limitations
        void[] numbersBuf = GCAllocator.instance.allocate(100 * int.sizeof);
        if (!numbersBuf.ptr)
        {
            version (unittest)
                GC_printf("Failed to allocate numbers\n");
            return;
        }
        int* numbers = cast(int*) numbersBuf.ptr;

        // Populate array
        foreach (i; 0 .. 100)
        {
            numbers[i] = cast(int) i;
        }

        // Print elements
        foreach (n; numbers[0 .. 100])
        {
            GC_printf("%d ", n);
        }
        GC_printf("\n");
    }
    else
    {
        // Non-OSX: Run in a separate thread
        auto t = new Thread(() {
            // Register thread with BDWGC
            auto threadGuard = ThreadGuard.create();

            void[] numbersBuf = GCAllocator.instance.allocate(100 * int.sizeof);
            if (!numbersBuf.ptr)
            {
                version (unittest)
                    GC_printf("Failed to allocate numbers in thread\n");
                return;
            }
            int* numbers = cast(int*) numbersBuf.ptr;

            // Populate array
            foreach (i; 0 .. 100)
            {
                numbers[i] = cast(int) i;
            }

            // Print elements
            foreach (n; numbers[0 .. 100])
            {
                GC_printf("%d ", n);
            }
            GC_printf("\n");
        });
        t.start();
        t.join();
    }
}
