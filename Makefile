all: vec_add_c vec_add_cuda

vec_add_c: vector_addition.c
	@gcc -o vec_add_c vector_addition.c -lm

vec_add_cuda: vector_addition.cu
	@nvcc -o vec_add_cuda vector_addition.cu

clean:
	@rm -f vec_add_c
	@rm -f vec_add_cuda
