#include <stdio.h>
#include <stdlib.h>

int main() {
	//สýื้ ึธี๋
	float a[10];
	float* p = (float*)malloc(10 * sizeof(float));
	for (int i = 0; i < 10; i++) {
		a[i] = i;
		p[i] = 10-i;
		if (a[i] == p[i]) {
			a[i] = -1;
			p[i] = -1;
		}
	}
}