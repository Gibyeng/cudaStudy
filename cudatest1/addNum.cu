#include <iostream>
#include <cuda.h>
using namespace std;

__global__ void AddIntsCUDA(int* a, int* b) {
	for (int i = 0; i < 1000005; i++) {
		a[0] += b[0];
	}
}

int main() {
	int a = 0;
	int b = 1;
	int *d_a, *d_b;
	cudaMalloc(&d_a, sizeof(int));
	cudaMalloc(&d_b, sizeof(int));
	
	cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);

	AddIntsCUDA << <1, 1 >> > (d_a, d_b);
	cudaMemcpy(&a, d_a, sizeof(int), cudaMemcpyDeviceToHost);
	cout << "The anwer is " << a << endl;
	cudaFree(d_a);
	cudaFree(d_b);
	return 0;
}