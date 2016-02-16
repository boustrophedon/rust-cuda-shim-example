#include <stdio.h>
#include "logmin.h"

__global__ void logmin(int64_t *d_nums, size_t size) {
	int64_t idx = threadIdx.x + blockDim.x*blockIdx.x;
	if (2*idx < size) {
		int64_t n1 = d_nums[2*idx];
		int64_t n2 = (2*idx+1 < size) ? d_nums[2*idx+1] : n1;

		d_nums[idx] = (n1 < n2) ? n1 : n2;
	}
}

int64_t run_logmin(int64_t* array, size_t array_len) {
	size_t array_size = sizeof(int64_t)*array_len;
	int64_t *h_nums = array;
	int64_t *final_nums = (int64_t*)malloc(array_size);

	int64_t *d_nums;
	cudaError err = cudaMalloc((void **)&d_nums, array_size);
	
	if (err != cudaSuccess) {
		fprintf( stderr, "Cuda error in file '%s' in line %i : %s.\n",
					 __FILE__, __LINE__, cudaGetErrorString( err) );		
	}

	err = cudaMemcpy(d_nums, h_nums, array_size, cudaMemcpyHostToDevice);
	if (err != cudaSuccess) {
		fprintf( stderr, "Cuda error in file '%s' in line %i : %s.\n",
					 __FILE__, __LINE__, cudaGetErrorString( err) );		
	}

	// this blocksize and gridsize obviously does not work for all values of array_len
	size_t blocksize = 512;
	size_t gridsize = (array_len/blocksize)+1;
	for (int64_t size = array_len; size > 1; size = size%2+size/2) {
		logmin<<<gridsize,blocksize>>>(d_nums, size);

		err = cudaPeekAtLastError();
		if (err != cudaSuccess) {
			fprintf( stderr, "Cuda error in file '%s' in line %i : %s.\n",
						 __FILE__, __LINE__, cudaGetErrorString( err) );		
		}

		err = cudaMemcpy(final_nums, d_nums, array_size, cudaMemcpyDeviceToHost);
		if (err != cudaSuccess) {
			fprintf( stderr, "Cuda error in file '%s' in line %i : %s.\n",
						 __FILE__, __LINE__, cudaGetErrorString( err) );		
		}
		// for (int64_t i = 0; i < size%2+size/2; i++) {
		// 	printf("%2d ", final_nums[i]);
		// }
		// printf("\n");
	}
	return final_nums[0];
}

int64_t run_linmin(int64_t *array, size_t array_size) {
	int64_t *nums = array;

	int64_t min = nums[0];
	for (size_t i = 0; i < array_size; i++) {
		min = (nums[i]<min) ? nums[i] : min;
	}
	return min;
}

int64_t *gen_array(size_t size) {
	int64_t *array = (int64_t*)malloc(sizeof(int64_t)*size);
	for (size_t i = 0; i < size; i++) {
		array[i] = 10289*(i+1)%20269;
	}
	return array;
}
