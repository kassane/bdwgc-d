import bdwgc;

extern (C++)
{
    struct Person
    {
        char* name;
        int age;
        Person* people;
    }

    Person createPerson(const(char)* name, int age);
}
extern (C):
void main()
{
    GC_init();
    GC_set_all_interior_pointers(1);

    Person p1 = createPerson("John", 42);
    Person p2 = createPerson("Sarah", 35);
    GC_gcollect();
    GC_printf("%s, have %d years old.\n", p1.name, p1.age);
    GC_printf("%s, have %d years old.\n", p2.name, p2.age);
}
pragma(printf)
void GC_printf(const(char)* format, ...);
