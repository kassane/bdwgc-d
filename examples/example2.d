/++
 + Example using the BDWGC allocator to allocate an array of strings,
 + duplicate strings, and print them.
 +/
import bdwgc;
import core.stdc.string : strlen, strcpy;

extern (C)
void main() @trusted
{
    // Allocate array
    char*[] names = (cast(char**) GCAllocator.instance.allocate((char*).sizeof * 3).ptr)[0 .. 3];

    // Source strings
    const(char)*[3] src = ["Alice", "Bob", "Charlie"];

    // Copy strings into GC-managed memory
    foreach (i; 0 .. src.length)
    {
        size_t len = strlen(src[i]) + 1;
        names[i] = cast(char*) GCAllocator.instance.allocate(len).ptr;
        if (!names[i])
        {
            version (unittest)
                GC_printf("Failed to allocate string %ld\n", i);
            foreach (j; 0 .. i)
                GCAllocator.instance.deallocate(names[j][0 .. strlen(names[j]) + 1]);
            GCAllocator.instance.deallocate(names[0 .. 3]);
            return;
        }
        strcpy(names[i], src[i]);
    }

    // Print names
    foreach (name; names)
        GC_printf("Name: %s\n", name);
}
