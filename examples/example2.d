/++
 + Concise example using the BoehmAllocator with std.experimental.allocator.makeArray
 + to allocate and print an array of strings.
 +/
import bdwgc;
import core.stdc.string : strlen, strcpy;
import std.experimental.allocator : makeArray;

extern (C) @trusted
void main()
{
    auto guard = ThreadGuard.create();

    // Allocate array of 3 char* pointers using makeArray
    char*[] names = makeArray!(char*)(BoehmAllocator.instance, 3);
    if (!names.ptr)
    {
        debug
            GC_printf("Failed to allocate names array\n");
        return;
    }

    // Copy strings into GC-managed memory
    string[3] src = ["Alice", "Bob", "Charlie"];
    foreach (i, s; src)
    {
        auto len = strlen(s.ptr) + 1;
        names[i] = cast(char*) BoehmAllocator.instance.allocate(len).ptr;
        if (!names[i])
        {
            debug
                GC_printf("Failed to allocate string %d\n", cast(int)i);
            BoehmAllocator.instance.deallocate(names);
            return;
        }
        strcpy(names[i], s.ptr);
    }

    // Print names
    foreach (name; names)
        GC_printf("Name: %s\n", name);
}
