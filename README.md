# Overview

This project is to demonstrate calling conventions between 32-bit and 64-bit using windows x86 ABI

The following functions were implemented in 64-bit and 32-bit
```c
/**
 * @param str - the string to find the length of
 * 
 * @returns the length of the string
 */
int ccStrLen(char* str);

/**
 * @param dst  - dst buffer
 * @param src   - source buffer
 * @param n     - number of elements to copy
 */
void* ccmemcpy(void* dst, void* src, int n);

/**
 * @param dst   - dst
 * @param c     - the int to fill the dst
 * @param n     - the size of the 
 */
void* ccmemset(void* dst, int c, int n);

/**
 * @param digit     -   the char to check if is digit [0-9]
 * 
 * @returns
 * 1 if is digit
 * 0 if not digit
 */
int ccisdigit(char digit);

/**
 * @param c     - the string of chars to be converted to an int
 * 
 * @returns
 * value represented as a signed int
 * will stop at first non digit char
 * returns 0 by default
 */
int ccatoi(char* c);

/**
 * @note        this function was only implemented in 64-bit
 * @returns     = ((i1 + i2) * (i3 + i4) * (i5 + i6)) / i7
 */
extern int ccmanyArgs64(int i1, int i2, int i3, int i4, int i5, int i6, int i7);
```

## 64-bit
In the Windows x86_64 calling convention the first 4 arguments are passed into the registers rcx, rdx, r8, and r9. The rest are added to the stack in right-to-left order

Example:

```c
extern int ccmanyArgs64(int i1, int i2, int i3, int i4, int i5, int i6, int i7);
```
Stack example of ccmanyArgs64

| Stack                 |   offset       |
|   ---                 |   ---          |
|   i7                  |   rbp +   72   |
|   i6                  |   rbp +   64   |
|   i5                  |   rbp +   56   |
| shadow space          |   rbp +   48   |
| shadow space          |   rbp +   40   |
| shadow space          |   rbp +   32   |
| shadow space          |   rbp +   24   |
| return address        |   rbp + 8      |
| previous rbp          |   rbp          |

> ***Assuming the stack is 16 byte aligned***
>
> **NOTE: In windows x86_64 32 bytes of shadow space is reserved by the caller**
>
> **NOTE: Exact offsets heavily depend on function prologue, pushes, and stack allocation. The following is for this function in particular.**



|   Registers | Value               |
|   ---       | ---                 |
|   rax       | volatile (undefined)|
|   rbx       | callee-preserved    |
|   rcx       | first-arg (i1)      |
|   rdx       | second-arg (i2)     |
|   r8        | third-arg (i3)      |
|   r9        | fourth-arg  (i4)    |

## 32-bit

The 32-bit example uses the cdecl calling convention where arguments are pushed right-to-left and the caller cleans the stack.

### example memcpy32
```c
void* memcpy32(void* dst, void* src, int n);
```

| Stack             |   offset      |
|   ---             |   ---         |
|   n               |   ebp +   16  |
|   src             |   ebp +   12  |
|   dst             |   ebp +   8   |
|   return address  |   ebp +   4   |
|   frame pointer of caller | ebp  |

## Local variables

```x86_64
push rbp                ; push rbp to the stack
mov rbp, rsp            ; frame setup
sub rsp, 32             ; reserve 32 bytes of space
mov [rbp - 8], rax      ; move rax to local var of [rbp - 8]

add rsp, 32             ; add 32 bytes back to clean stack
add rsp, 32             ; restore stack
pop rbp                 ; restore caller frame pointer
ret
```