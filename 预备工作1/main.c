#include <stdio.h>

//ì³²¨ÄÇÆõ
int main() {
	int a, b, i, t, n;

	a = 0;
	b = 1;
	i = 1;
	while (i < n) {
		t = b;
		b = a + b;
		a = t;
		i = i + 1;
	}
}
