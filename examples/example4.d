import bdwgc;

extern (C++)
{
    struct Person
    {
        char* name;
        int age;
        Person* people;
    }

    Person* newPerson();
    void createPerson(Person* p, const(char)* name, int age);
}
extern (C)
void main()
{
    GC_init();
    GC_set_all_interior_pointers(1);

    auto p1 = newPerson();
    auto p2 = newPerson();
    createPerson(p1, "John", 42);
    createPerson(p2, "Sarah", 35);
    GC_gcollect();
    GC_printf("%s, have %d years old.\n", p1.name, p1.age);
    GC_printf("%s, have %d years old.\n", p2.name, p2.age);
}
