module bdwgc;
public import gc;

version (Windows)
{
    private import core.stdc.stdio : printf;
    alias GC_printf = printf;
}
else
{
    pragma(printf)
    extern (C) void GC_printf(const(char)* format, ...);
}

@("GC initialization")
@system unittest
{
    GC_init();

    for (auto i = 0; i < 1024; i++)
    {
        auto mem = cast(size_t*) GC_malloc(size_t.sizeof * 4);

        *(mem + 0) = 0;
        *(mem + 1) = 1;
        *(mem + 2) = 2;
        *(mem + 3) = 3;

        assert(*(mem++) == 0);
        assert(*(mem++) == 1);
        assert(*(mem++) == 2);
        assert(*(mem++) == 3);
    }
}

@("GC incremental")
@system unittest
{
    GC_init();
    GC_enable_incremental();

    for (auto i = 0; i < 1024; i++)
    {
        auto mem = GC_malloc(size_t.sizeof * 4);
        GC_free(mem);
    }
}
