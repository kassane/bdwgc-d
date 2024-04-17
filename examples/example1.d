import bdwgc;
import core.stdc.stdio;

extern (C)
void main()
{
    GC_init();
    for (auto i = 0; i < 1024; i++)
    {
        printf("allocating %d\n", i);
        auto mem = GC_malloc(size_t.sizeof * 4);
        GC_free(mem);
        printf("freed %d\n", i);
    }
}
