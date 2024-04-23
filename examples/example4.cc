#include <gc_cpp.h>

struct Person {
  char *name;
  int age;
};
Person *newPerson() { return GC_NEW(Person); }
void createPerson(Person* p, const char *name, int age) {
  p->name = GC_strdup(name);
  p->age = age;
}
