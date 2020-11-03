CC       = pgcc
CUDA_PATH = /opt/pgi/13.10.0/linux86-64/2013/cuda/5.0
CCFLAGS  = -I$(CUDA_PATH)/include -L$(CUDA_PATH)/lib64 -lcudart -lcufft
ACCFLAGS = -acc -ta=nvidia -Minfo=accel -Minline
OMPFLAGS = -fast -mp -Minfo=mp

BIN =  cufft_acc

all: $(BIN)

cufft_acc: cufft_acc.c
	$(CC) $(CCFLAGS) $(ACCFLAGS) -o $@ $<
	
clean:
	$(RM) $(BIN)
