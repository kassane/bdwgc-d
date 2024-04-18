#include <gc_cpp.h>

struct Person {
  char* name;
  int age;
  Person* people;
};

Person createPerson(const char* name, int age) {
  Person p;
  p.name = GC_strdup(name);
  p.age = age;
  p.people = static_cast<Person*>(GC_malloc(sizeof(Person)));
  // FIXME: undefined reference to `__gxx_personality_v0'
  // p.people = gc_allocator<Person>().allocate(1);
  return p;
}
