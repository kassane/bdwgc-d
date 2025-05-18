/++
 + Example using the BDWGC allocator to allocate an array of strings,
 + duplicate strings, and print them.
 +/
import bdwgc;

extern (C) @trusted @nogc nothrow
void main()
{
    // Allocate array of 3 char* pointers
    void[] namesBuf = GCAllocator.instance.allocate((char*).sizeof * 3);
    if (!namesBuf.ptr)
    {
        version (unittest)
            GC_printf("Failed to allocate names array\n");
        return;
    }
    char** names = cast(char**) namesBuf.ptr;

    // Duplicate strings
    names[0] = GC_strdup("John");
    names[1] = GC_strdup("Sarah");
    names[2] = GC_strdup("Bob");

    // Verify allocations
    if (!names[0] || !names[1] || !names[2])
    {
        GCAllocator.instance.deallocate(namesBuf);
        return;
    }

    // Print names
    for (int i = 0; i < 3; i++)
    {
        GC_printf("Name: %s MTX\n", names[i]);
    }

    // Deallocate (optional, as BDWGC will collect)
    GCAllocator.instance.deallocate(namesBuf);
}
