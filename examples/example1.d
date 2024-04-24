import bdwgc;

enum max = 10_000_000;

extern (C)
void main()
{
    GC_init();

    foreach (i; 0 .. max)
    {
        auto p = cast(int**) GC_malloc(size_t.sizeof);
        auto q = cast(int*) GC_malloc(size_t.sizeof);
        *p = cast(int*) GC_realloc(q, size_t.sizeof * 2);
        if (i % 100_000 == 0)
        {
            const heap = GC_get_heap_size();
            version (Windows)
            {
                GC_printf("heap size: %d\n", heap);
            }
            else
            {
                GC_printf("heap size: %ld\n", heap);
            }
        }
    }
}
