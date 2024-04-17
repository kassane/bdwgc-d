import bdwgc;
import core.stdc.stdio;

extern (C)
void main()
{
    GC_init();

    // Create an array of strings
    char** names = cast(char**) GC_malloc(char.sizeof * 3);
    names[0] = GC_strdup("John");
    names[1] = GC_strdup("Sarah");
    names[2] = GC_strdup("Bob");

    // Print names
    for (int i = 0; i < 3; i++)
    {
        printf("Name: %s\n", names[i]);
    }
}
