#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE 100000
#define CALLS 500000

// The functions write into the array and store a result here
// Because it is volatile, the compiler cannot remove the arrays as unused
volatile int sink;

void staticArray(void) {
    static int arr[SIZE];
    arr[0] = 1;
    arr[SIZE - 1] = 2;
    sink = arr[0] + arr[SIZE - 1];
}

void stackArray(void) {
    int arr[SIZE];
    arr[0] = 1;
    arr[SIZE - 1] = 2;
    sink = arr[0] + arr[SIZE - 1];
}

void heapArray(void) {
    int *arr = malloc(SIZE * sizeof(int));
    arr[0] = 1;
    arr[SIZE - 1] = 2;
    sink = arr[0] + arr[SIZE - 1];
    free(arr); // has to be freed manually
}

// calls f() CALLS amount of times and returns the time in milliseconds
double measure(void (*f)(void)) {
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < CALLS; i++) {
        f();
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    return (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1e6;
}

int main(void) {
    printf("Array size: %d ints (%lu KB)\n", SIZE, SIZE * sizeof(int) / 1024);
    printf("Calls per function: %d\n\n", CALLS);

    double tStatic = measure(staticArray);
    double tStack = measure(stackArray);
    double tHeap = measure(heapArray);

    printf("static: %.3f ms (%.2f ns per call)\n", tStatic, tStatic * 1e6 / CALLS);
    printf("stack: %.3f ms (%.2f ns per call)\n", tStack, tStack * 1e6 / CALLS);
    printf("heap: %.3f ms (%.2f ns per call)\n", tHeap, tHeap * 1e6 / CALLS);
    return 0;
}
