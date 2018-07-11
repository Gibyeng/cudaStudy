#include<iostream>
#include<cuda.h>
#include<stdlib.h>
#include<ctime>

using namespace std;

__global__ void AddInts(int *a, int *b,int count) {
	int id = blockIdx.x*blockDim.x + threadIdx.x;
	if (id < count) {
		a[id] += b[id];
	}
}

int main() {
	int count = 1000;
	srand(time(NULL));
	int *h_a = new int[count];
	int *h_b = new int[count];
	for (int i = 0;  i < count; i++) {
		h_a[i] = rand() % 1000;
		h_b[i] = rand() % 1000;
	}
	cout << "prior to addition:" << endl;
	for (int i = 0; i < 5; i++) {
		cout << h_a[i] << " " << h_b[i] << endl;
	}

	int *d_a, *d_b;
	cudaMalloc(&d_a, sizeof(int)*count);
	cudaMalloc(&d_b, sizeof(int)*count);
	cudaMemcpy(d_a, h_a, sizeof(int)*count, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, sizeof(int)*count, cudaMemcpyHostToDevice);

	AddInts << <count / 256 + 1, 256 >> > (d_a, d_b, count);
	cudaMemcpy(h_a, d_a, sizeof(int)*count, cudaMemcpyDeviceToHost);
	for (int i = 0; i < 5; i++) {
		cout << "It is" << h_a[i] << endl;
	}
	cudaFree(d_a);
	cudaFree(d_b);
	delete[] h_a;
	delete[] h_b;

	return 0;

}