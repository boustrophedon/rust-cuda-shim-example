#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>

#include "logmin.h"

int main(int argc, char *argv[]) {
	int is_log = 1;
	int arraysize = 10;
	int check_result = 0;
	if (argc == 2) {
		is_log = atoi(argv[1]);
	}
	else if (argc == 3) {
		is_log = atoi(argv[1]);
		arraysize = atoi(argv[2]);
	}
	else if (argc == 4) {
		is_log = atoi(argv[1]);
		arraysize = atoi(argv[2]);
		check_result = 1;
	}

	if (is_log != 0 && is_log != 1) {
		printf("first argument must be either 0 or 1\n");
		return 1;
	}

	int result;
	int64_t *array = gen_array(arraysize);
	if (is_log) {
		result = run_logmin(array, arraysize);
		if (check_result) {
			int64_t linresult = run_linmin(array, arraysize);
			if (linresult != result) {
				printf("results did not match: linresult == %ld\n", linresult);
			}
		}
	}
	else {
		result = run_linmin(array, arraysize);
		if (check_result) {
			int64_t logresult = run_logmin(array, arraysize);
			if (logresult != result) {
				printf("results did not match: logresult == %ld\n", logresult);
			}
		}
	}
	printf("min: %d\n", result);
	return 0;
}

