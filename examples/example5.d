import bdwgc;
import std.algorithm;
import std.random;

template RingBuffer(T)
{
    struct RingBuffer
    {
    private:
        T[] buffer;
        size_t capacity;
        size_t head;
        size_t tail;
        size_t size_;

    public:
        this(size_t capacity) nothrow @safe
        {
            this.capacity = capacity;
            this.head = 0;
            this.tail = 0;
            this.size_ = 0;
            this.buffer.length = capacity;
        }

        void push(const T item)
        {
            if (size_ == capacity)
            {
                GC_printf("Ring buffer is full, dropping oldest element\n");
                pop();
            }
            if (canFind(buffer[head .. tail], item))
            {
                version (Debug)
                    GC_printf("Item already present in the buffer, skipping\n");
                return;
            }
            buffer[tail] = item;
            tail = (tail + 1) % capacity;
            size_++;
        }

        T pop()
        {
            if (size_ == 0)
            {
                GC_printf("Ring buffer is empty\n");
                return T.init;
            }
            auto item = buffer[head];
            head = (head + 1) % capacity;
            size_--;
            return item;
        }

        T opIndex(size_t index) const nothrow @safe @nogc
        {
            assert(index < size_);
            return buffer[(head + index) % capacity];
        }

        @property size() const pure nothrow @nogc @safe
        {
            return size_;
        }

        void print() const
        {
            GC_printf("Ring Buffer Contents:\n");
            foreach (i; 0 .. size_)
            {
                GC_printf("%d ", buffer[(head + i) % capacity]);
            }
            GC_printf("\n");
        }
    }
}

void bubbleSort(T)(RingBuffer!T arr) @nogc nothrow
{
    size_t n = arr.size;
    for (size_t i = 0; i < n - 1; ++i)
    {
        for (size_t j = 0; j < n - i - 1; ++j)
        {
            if (arr[j] > arr[j + 1])
            {
                auto temp = arr.opIndex(j);
                arr.buffer[j] = arr.opIndex(j + 1);
                arr.buffer[j + 1] = temp;
            }
        }
    }
}

extern (C):
void main()
{
    GC_init();
    RingBuffer!int ringBuffer = RingBuffer!int(99);
    auto rd = Random(unpredictableSeed);
    foreach (_; 0 .. 100)
    {
        auto randomNumber = uniform(1, 99, rd);
        ringBuffer.push(randomNumber);
    }

    ringBuffer.print();
    auto popped = ringBuffer.pop();

    GC_printf("Popped element: %d\n", popped);
    ringBuffer.print();
    bubbleSort(ringBuffer);

    GC_printf("Sorted array: ");
    for (size_t i = 0; i < ringBuffer.size; ++i)
    {
        GC_printf("%d ", ringBuffer[i]);
    }
    GC_printf("\n");
}

pragma(printf)
void GC_printf(const(char)* format, ...);
