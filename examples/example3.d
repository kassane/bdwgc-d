import bdwgc;
import core.memory;
import core.thread;

void main()
{
    GC_init(); // Initialize GC
    GC_enable_incremental();

    GC_start_incremental_collection();

    auto t = new Thread(() {
        int* numbers = cast(int*) GC_malloc(100 * int.sizeof);

        // Populate array
        foreach (i; 0 .. 100)
        {
            numbers[i] = i;
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
