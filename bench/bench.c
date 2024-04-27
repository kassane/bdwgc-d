#include <gc.h>

#define NUM_OBJS 1000000

int main() {

  GC_INIT();

  int i;
  for (i = 0; i < NUM_OBJS; i++) {
    int *p = GC_MALLOC(sizeof(int));
    *p = i;
  }

  GC_gcollect();

  return 0;
}
