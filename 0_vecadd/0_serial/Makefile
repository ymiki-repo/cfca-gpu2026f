# environment
CC	:= gcc
# CC	:= nvc

# option(s)
STD	:= -std=c99
CFLAGS	:= -Wall -Wextra -Wshadow
CFLAGS	+= -O3 -ffast-math
# CFLAGS	+= -O3 -fast -Minfo=accel,opt,mp,stdpar
# CFLAGS	+= -pg

# source(s)
SRC	:= vecadd.c

# object(s)
OBJ	:= $(patsubst %.c, %.o, $(notdir $(SRC)))

# executable(s)
EXEC	:= vecadd
all:	$(EXEC)

# rule(s)
$(EXEC):	$(OBJ)
	$(CC) $(STD) $(CFLAGS) $(ARGS) -o $@ $(OBJ) -lm
%.o:	%.c
	$(CC) $(STD) $(CFLAGS) $(ARGS) -o $@ -c $<

# clean up
clean:
	rm -rf $(EXEC) $(OBJ)
