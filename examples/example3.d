/++
 + -betterC compatible example using the BoehmAllocator in a threaded context
 + to allocate, populate, and print an array of integers.
 +/
import bdwgc;
version (Posix)
    import core.sys.posix.pthread;
version (Windows)
    import core.sys.windows.windows;

extern (C) @nogc nothrow:

// Thread function to allocate, populate, and print integers
private void* threadFunc(void* arg) @trusted
{
    // Register thread with BDWGC
    auto threadGuard = ThreadGuard.create();

    void[] numbersBuf = BoehmAllocator.instance.allocate(100 * int.sizeof);
    if (!numbersBuf.ptr)
    {
        debug
            GC_printf("Failed to allocate numbers in thread\n");
        return null;
    }
    int[] numbers = (cast(int*) numbersBuf.ptr)[0 .. 100];

    // Populate array
    foreach (i; 0 .. 100)
        numbers[i] = cast(int) i;

    // Print elements
    foreach (n; numbers)
        GC_printf("%d ", n);
    GC_printf("\n");

    return null;
}

void main() @trusted
{
    // Enable leak detection and incremental GC
    GC_set_find_leak(1);
    BoehmAllocator.instance.enableIncremental();
    GC_start_incremental_collection();

    // Register main thread
    auto mainGuard = ThreadGuard.create();

    version (OSX)
    {
        // macOS: Run in main thread
        void[] numbersBuf = BoehmAllocator.instance.allocate(100 * int.sizeof);
        if (!numbersBuf.ptr)
        {
            debug
                GC_printf("Failed to allocate numbers\n");
            return;
        }
        int[] numbers = (cast(int*) numbersBuf.ptr)[0 .. 100];

        // Populate array
        foreach (i; 0 .. 100)
            numbers[i] = cast(int) i;

        // Print elements
        foreach (n; numbers)
            GC_printf("%d ", n);
        GC_printf("\n");
    }
    else version (Posix)
    {
        // POSIX: Create a thread
        pthread_t thread;
        if (pthread_create(&thread, null, &threadFunc, null) != 0)
        {
            debug
                GC_printf("Failed to create thread\n");
            return;
        }
        pthread_join(thread, null);
    }
    else version (Windows)
    {
        // Windows: Create a thread
        HANDLE thread = CreateThread(null, 0, cast(LPTHREAD_START_ROUTINE) &threadFunc, null, 0, null);
        if (thread == null)
        {
            debug
                GC_printf("Failed to create thread\n");
            return;
        }
        WaitForSingleObject(thread, INFINITE);
        CloseHandle(thread);
    }
}
