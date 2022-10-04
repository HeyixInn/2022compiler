#include <stdio.h>
#include <stdlib.h>

//斐波那契
//int main() {
//	int a, b, i, t, n;
//
//	a = 0;
//	b = 1;
//	i = 1;
//	scanf_s("%d", &n);
//	printf("%d", a);
//	printf("%d", b);
//
//	while (i < n) {
//		t = b;
//		b = a + b;
//		printf("%d", b);
//		a = t;
//		i = i + 1;
//	}
//}

//int main() {
//	//数组 指针
//	float a[10];
//	float* p = (float*)malloc(10 * sizeof(float));
//	for (int i = 0; i < 10; i++) {
//		a[i] = i;
//		p[i] = 10-i;
//		if (a[i] == p[i]) {
//			a[i] = -1;
//			p[i] = -1;
//		}
//	}
//}
int test(int a, int b) {
	return a + b + 3;
}
int main() {
	int a = test(1, 2);
	printf("%d", a);
	return 0;
}