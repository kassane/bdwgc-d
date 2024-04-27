import core.memory;

enum NUM_OBJS = 1_000_000;

void main()
{

    foreach (i; 0 .. NUM_OBJS)
    {
        int* p = new int;
        *p = i;
    }

    GC.collect();

}
