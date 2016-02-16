NVCC=nvcc

CUDA_C_CFLAGS=-Xcompiler -fPIC

ifeq ($(strip $(CARGO_BUILD_DIR)),)
	OBJDIR=$(CURDIR)
else
	OBJDIR=$(CARGO_BUILD_DIR)
endif

all: logmin liblogmin

logmin: $(OBJDIR)/logmin

liblogmin: $(OBJDIR)/liblogmin.a

$(OBJDIR)/logmin: $(OBJDIR)/logmin.o main.c
	$(NVCC) $^ -o $@

$(OBJDIR)/logmin.o: logmin.cu
	$(NVCC) $(CUDA_C_CFLAGS) -c $< -o $@

$(OBJDIR)/liblogmin.a: $(OBJDIR)/logmin.o
	ar cr $@ $<

clean:
	rm $(OBJDIR)/*.o $(OBJDIR)/*.a $(OBJDIR)/logmin
