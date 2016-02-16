#ifndef LOGMIN_H_
#define LOGMIN_H_

#ifdef __cplusplus
extern "C" {
#endif

int64_t run_logmin(int64_t* array, size_t array_len);
int64_t run_linmin(int64_t *array, size_t array_size);

int64_t *gen_array(size_t size);

#ifdef __cplusplus
}
#endif

#endif // LOGMIN_H_
