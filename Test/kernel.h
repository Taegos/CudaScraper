#pragma once
#include <vector>
#include <string>
#include <functional>

#define API __declspec(dllexport)

namespace cudastatistics {

	struct SecretParams {
		int min_len;
		int max_len;
		float min_rand_score;
	};

	struct StringArray {
		char* data;
		int* indices;
		size_t indices_len;
	};

	API bool init(std::string&);
	API std::vector<std::string> filter_files(const std::vector<std::string>&, int, const SecretParams& params);
}