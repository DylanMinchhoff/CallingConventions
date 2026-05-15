#include <stdlib.h>
#include <stdio.h>
extern int ccStrLen32(char* str);
extern void* ccmemcpy32(void* dst, void* src, int n);
extern void* ccmemset32(void* dst, int c, long n);

extern int ccisdigit32(char digit);
extern int ccatoi32(char* c);

int main(int argc, char* argv) {
    // char* test = "hello\n";
    printf("Before function call\n");
    // char buff[256];
    // int len = ccStrLen32(test);

    // printf("len = %d\n", len);
    // ccmemcpy32(buff, test, len + 1);
    // printf(buff);

    // ccmemset32(buff, 'w', 20);
    // ccmemset32(buff + 20, '\n', 20);
    // ccmemset32(buff + 21, 0, 20);
    // printf(buff);

    printf("Before function");

    printf("isDigit(a): %d\n", ccisdigit32('a'));
    printf("isDigit(0): %d\n", ccisdigit32('0'));
    printf("isDigit(9): %d\n", ccisdigit32('9'));
    printf("isDigit(NULL_CHAR): %d\n", ccisdigit32('\0'));
    
    printf("1 : %d\n", ccatoi32("1"));
    printf("0 : %d\n", ccatoi32("0"));
    printf("abc : %d\n", ccatoi32("abc"));
    printf("- : %d\n", ccatoi32("-"));
    printf("-2 : %d\n", ccatoi32("-2"));
    printf("-267 : %d\n", ccatoi32("-267"));
    printf("173888 : %d\n", ccatoi32("173888"));
    printf("-23hj123 : %d\n", ccatoi32("-23hj123"));

    printf("\nEnd function");
    return 0;
}