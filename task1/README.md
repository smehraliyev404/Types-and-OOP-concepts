# Task 1 | Technical Documentation

## Overview

Three C functions declare the same large array in three different ways:

| Function | Declaration | Storage |
|---|---|---|
| `staticArray()` | `static int arr[SIZE];` | static |
| `stackArray()` | `int arr[SIZE];` | fixed stack-dynamic |
| `heapArray()` | `int *arr = malloc(SIZE * sizeof(int)); ... free(arr);` | fixed heap-dynamic |

Each function is called 500000 times and the total time of each is printed.

## Structure

```
task1/
├── code/
│   └── arrays.c // the three functions, measure() and main()
└── README.md
```

- `SIZE` and `CALLS` are `#define`s at the top of the file.
- Every function writes the first and last element and saves their sum in a `volatile sink`. Without this, the compiler could see that the array is never used and remove it.
- `measure(f)` calls a function `CALLS` amount of times and returns the time in ms, using `clock_gettime(CLOCK_MONOTONIC)`.

## Requirements

- A C compiler (`gcc` or `clang`).
- `clock_gettime` is POSIX, so it works on macOS and Linux. On Windows it needs MinGW or WSL.

## How to run

From the `task1` folder:

```bash
gcc code/arrays.c -o arrays
```

```bash
./arrays
```

## Sample output

One run:

```
Array size: 100000 ints (390 KB)
Calls per function: 500000

static: 1.602 ms (3.20 ns per call)
stack: 2.398 ms (4.80 ns per call)
heap: 56.877 ms (113.75 ns per call)
```

Four runs in a row (ms for 500000 calls):

| Run | static | stack | heap |
|---|---|---|---|
| 1 | 2.529 | 3.704 | 67.240 |
| 2 | 1.602 | 2.398 | 56.877 |
| 3 | 1.654 | 2.420 | 57.040 |
| 4 | 1.658 | 1.973 | 56.367 |
| avg | 1.861 | 2.624 | 59.381 |

The numbers change a little between runs. The first run is always a bit slower, probably because the CPU is still warming up. But the order is always the same: static is slightly faster than stack, and both are much faster than heap. Heap is about 32 times slower than static and about 23 times slower than stack.

## Discussion

The static array is the fastest. It is bound to memory before execution begins and keeps the same cell the whole time. So a call does no allocation at all, and the 3 ns are just the function call and the two writes. The cost is flexibility: there is only one copy of the array, shared by every call, so a recursive function could not have its own copy.

The stack array is almost as fast. Its storage is created when the declaration is elaborated, which means on every call. In practice the function just moves the stack pointer down by 390 KB when it starts and back up when it returns, which is why it is only about 1 ns slower than static. I wanted to see where that extra time comes from, so I checked the binary with `nm -u arrays` and `objdump -d arrays`. Because the frame is so large, clang adds a call to `___chkstk_darwin`, which touches the new stack pages one by one so that the program does not jump over the guard page. There is also a stack-protector check (`___stack_chk_guard`). So the "overhead of allocation and deallocation" is real, but very small.

The heap array is by far the slowest. `malloc` and `free` call the memory allocator at runtime. Every time the allocator has to find a free block of the right size, record it, and later put it back, and that is a lot more work than moving one register. Heap-dynamic variables are "inefficient and unreliable", and the result shows the first part. The second part is about reliability: if I forget `free`, the program leaks 390 KB on every call, and the compiler would not warn me.

So the faster the storage, the less flexible it is. Static gives speed but only one copy. Stack gives a fresh copy per call (so recursion works) almost for free, but the size must be known and fit in the stack. Heap is the only one where the array can outlive the function or have its size decided at runtime, and it is the one you pay for.