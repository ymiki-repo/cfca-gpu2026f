# environment
CU	:= nvcc

GPU_ARCH	:= 80

# option(s)
STD	:= -std=c99
CUFLAGS	:= -O3 -gencode arch=compute_$(GPU_ARCH),code=sm_$(GPU_ARCH) -Xptxas -v,-warn-spills,-warn-lmem-usage -lineinfo

# source(s)
SRC	:= vecadd.cu

# object(s)
OBJ	:= $(patsubst %.cu,	%.o, $(notdir $(SRC)))

# executable(s)
EXEC	:= vecadd
all:	$(EXEC)

# rule(s)
$(EXEC):	$(OBJ)
	$(CU) $(CUFLAGS) -o $@ $(OBJ) -lm
%.o:	%.cu
	$(CU) $(CUFLAGS) -o $@ -c $<

# clean up
clean:
	rm -rf $(EXEC) $(OBJ)
