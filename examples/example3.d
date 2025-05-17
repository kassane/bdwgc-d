import bdwgc;
import core.memory;
import core.thread;

void main() @trusted
{
    GC_set_find_leak(1);
    GC_init(); // Initialize GC
    GC_enable_incremental();

    GC_start_incremental_collection();

    version (OSX)
    {
        // FIXME: OSX does not support this
    }
    else
    {
        auto t = new Thread(() {
            int* numbers = cast(int*) GC_MALLOC(100 * int.sizeof);

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

}
