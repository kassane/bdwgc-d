/++
 + Example using the BDWGC allocator to manage C++ Person structs,
 + populate them, collect garbage, and print details.
 +/
import bdwgc;

extern (C++)
{
    struct Person
    {
        char* name;
        int age;
        Person* people;
    }

    Person* newPerson() @nogc nothrow;
    void createPerson(Person* p, const(char)* name, int age) @nogc nothrow;
}

extern (C) @trusted @nogc nothrow
void main()
{
    // Enable interior pointer scanning (if needed)
    GC_set_all_interior_pointers(1);

    // Create and populate Person instances
    auto p1 = newPerson();
    auto p2 = newPerson();
    if (!p1 || !p2)
    {
        version (unittest)
            GC_printf("Failed to create Person instances\n");
        if (p1)
            GCAllocator.instance.deallocate(p1[0 .. Person.sizeof]);
        if (p2)
            GCAllocator.instance.deallocate(p2[0 .. Person.sizeof]);
        return;
    }

    createPerson(p1, "John", 42);
    createPerson(p2, "Sarah", 35);

    // Perform GC collection
    GCAllocator.instance.collect();

    // Print details
    GC_printf("%s, have %d years old.\n", p1.name, p1.age);
    GC_printf("%s, have %d years old.\n", p2.name, p2.age);

    // Deallocate (optional, as BDWGC will collect)
    GCAllocator.instance.deallocate(p1[0 .. Person.sizeof]);
    GCAllocator.instance.deallocate(p2[0 .. Person.sizeof]);
}
