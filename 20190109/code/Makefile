CFLAGS=-O3
CC=gcc
OPT=-Wall
OPT_1=-openmp
lib=-lgomp
path=-L/usr/local/lib
C_STD=-std=c99


SRCS=$(wildcard *.c)
exe=$(SRCS:.c=.exe)

default: $(exe)
%.exe: %.c
	$(CC) $< $(CFLAGS) $(OPT)  $(C_STD)  $(OPT_1)  -o $@ 

clean: 
	rm -rf  $(exe)

run:
	./run.sh

send:
	rsync -vrh  --progress  --exclude '*.exe' . uly:/home/hnguruwe/plasma_matmul/

recv:
	rsync -vrh  --progress --include  '*.dat'   uly:/home/hnguruwe/plasma_matmul/data/ 

plot:
	@python plot.py

.PHONY: clean run plot send recv