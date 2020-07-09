#include <stdio.h>

int prime(int x)
{
        int f = 1;
        for (int i = 2; i < x / 2 + 1; i++) {
                if (x % i == 0) { f = 0; break; }
        }
        return (f);
}

int main(void)
{
        int x, n;
        printf("x = ? "); scanf("%d", &x);
        for (n = 2; n <= x; n++) if (prime(n)) printf("%d ", n);
        printf("\n");
        return (0);
}
