#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <stddef.h>
extern int ccStrLen64(char* str);
extern void* ccmemcpy64(void* dst, void* src, long n);
extern void* ccmemset64(void* dst, int c, long n);
extern int ccmemcmp64(const void *ptr1, const void *ptr2, size_t num);

extern int ccisdigit64(char digit);
extern int ccatoi64(char* c);

/*
* = ((i1 + i2) * (i3 + i4) * (i5 + i6)) / i7
*/
extern int ccmanyArgs64(int i1, int i2, int i3, int i4, int i5, int i6, int i7);

int exampleMany(int i1, int i2, int i3, int i4, int i5, int i6, int i7) {
    return ((i1 + i2) * (i3 + i4) * (i5 + i6)) / i7;
}

int main(int argc, char* argv) {
    char* test = "hello\n";
    printf("Before function call");
    char buff[256];
    int len = ccStrLen64(test);

    printf("len = %d\n", len);
    ccmemcpy64(buff, test, len + 1);
    printf(buff);

    ccmemset64(buff, '0', 20);
    ccmemset64(buff + 20, '\n', 20);
    ccmemset64(buff + 21, 0, 20);
    // buff[21] = '\n';
    // buff[22] = '\0';
    printf(buff);
    // init_stackFrames();

    printf("Before function");
    
    printf("isDigit(a): %d\n", ccisdigit64('a'));
    printf("isDigit(0): %d\n", ccisdigit64('0'));
    printf("isDigit(9): %d\n", ccisdigit64('9'));
    printf("isDigit(NULL_CHAR): %d\n", ccisdigit64('\0'));
    
    printf("1 : %d\n", ccatoi64("1"));
    printf("0 : %d\n", ccatoi64("0"));
    printf("abc : %d\n", ccatoi64("abc"));
    printf("- : %d\n", ccatoi64("-"));
    printf("-0 : %d\n", ccatoi64("-0"));
    printf("-01 : %d\n", ccatoi64("-01"));
    printf("-2 : %d\n", ccatoi64("-2"));
    printf("-267 : %d\n", ccatoi64("-267"));
    printf("173888 : %d\n", ccatoi64("173888"));
    printf("-23hj123 : %d\n", ccatoi64("-23hj123"));

    printf("control: %d\n", exampleMany(1,1,2,2,3,3,2));
    printf("actual: %d\n", ccmanyArgs64(1,1,2,2,3,3,2));

    printf("End function");
    return 0;
}