#include "example4.h"

Person* newPerson() {
  Person* p = GC_NEW(Person);
  if (!p) {
    return nullptr;
  }
  p->name = nullptr; // Initialize to avoid dangling pointers
  p->age = 0;
  return p;
}

void createPerson(Person* p, const char* name, int age) {
  if (!p || !name) {
    return;
  }
  p->name = GC_strdup(name);
  if (!p->name) {
    return; // GC_strdup failed
  }
  p->age = age;
}
