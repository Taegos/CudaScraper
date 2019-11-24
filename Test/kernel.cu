
#include "kernel.h"
#include "device_launch_parameters.h"
#include "sm_60_atomic_functions.h"
#include <fstream>
#include <string>
#include <vector>
#include <mutex>
#include <thread>
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>
#include <iostream>

using namespace std;
using namespace cudastatistics;

__global__ void filter_kernel(cudastatistics::StringArray input, size_t file_max_word_count, size_t word_max_len, char* output)
{
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	int file_start = input.indices[idx];
	int file_end = input.indices[idx + 1];

	char* word = new char[word_max_len] { NULL };
	int word_len = 0;
	int word_count = 0;

	//NAGOT SKUMT

	for (int i = file_start; i < file_end; i++) {

		char ch = input.data[i];
		
		if (ch != ' ') {
			word[word_len] = ch;
			word_len++;			
		}
		else if (word_len > 0 ) {
			int output_idx = idx * file_max_word_count * word_max_len + word_count * word_max_len;
			memcpy(&output[output_idx], word, word_max_len * sizeof(char));
			word_count++;
			word_len = 0;
		}
	}

	if (word_len != 0) {
		int output_idx = idx * file_max_word_count * word_max_len + word_count * word_max_len;
		memcpy(&output[output_idx], word, word_max_len * sizeof(char));
	}

	delete[] word;
}

API bool cudastatistics::init(string& error) {
	cudaError_t cudaStatus;

	// Choose which GPU to run on, change this on a multi-GPU system.
	cudaStatus = cudaSetDevice(0);
	if (cudaStatus != cudaSuccess) {
		error = "cudaSetDevice failed!Do you have a CUDA - capable GPU installed?";
		return false;
	}	
	return true;
}

API void build_content(const vector<string>& file_paths, string& contents, vector<int>& indices) {

	int thread_count = thread::hardware_concurrency();
	int files_per_thread = file_paths.size() / thread_count;
	contents = "a  sdqwe  d fpewro kfqwe123";
	indices = {0, 4, 13, (int)contents.size()};
	return;

	vector<thread> threads;
	mutex mutex;

	for (int i = 0; i < thread_count; i++) {

		int start = i * files_per_thread;
		int end = start + files_per_thread;

		thread thread([&] {

			for (int i = start; i < end; i++) {
				const string& path = file_paths[i];
				ifstream fstream(path);
				string content((istreambuf_iterator<char>(fstream)),
					istreambuf_iterator<char>());

				mutex.lock();
				indices.push_back(contents.size());
				contents += content;
				mutex.unlock();
			}

			});

		threads.push_back(move(thread));

	}

	for (thread& thread : threads) {
		thread.join();
	}
}

//https://stackoverflow.com/questions/14038589/what-is-the-canonical-way-to-check-for-errors-using-the-cuda-runtime-api
#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char* file, int line, bool abort = true)
{
	if (code != cudaSuccess)
	{
		fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
		if (abort) exit(code);
	}
}

API vector<string> cudastatistics::filter_files(const vector<string>& file_paths, int result_max_len, const SecretParams& params) 
{
	string files = "hej va fo  abc dfg     mammma apa ";
	vector<int> file_indices = { 0, 5, 10, (int)files.size() };

	StringArray input_arr{ nullptr, nullptr, file_indices.size() };

	cudaMallocManaged(&input_arr.data, files.size() * sizeof(char));
	cudaMallocManaged(&input_arr.indices, file_indices.size() * sizeof(int));

	memcpy(input_arr.data, &files[0], files.size() * sizeof(char));
	memcpy(input_arr.indices, &file_indices[0], file_indices.size() * sizeof(int));

	size_t thread_count = file_indices.size() - 1;
	size_t file_max_word_count = 5;
	size_t word_max_len = 10;

	char* result;
	cudaMallocManaged(&result, thread_count * file_max_word_count * word_max_len * sizeof(char));

	filter_kernel << <1, thread_count >> > (input_arr, file_max_word_count, word_max_len, result);

	cudaDeviceSynchronize();

	int size = thread_count * file_max_word_count * word_max_len;

	for (int i = 0; i < size; i ++) {

		cout << result[i];
	}

	return {};
}
