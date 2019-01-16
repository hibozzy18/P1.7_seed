CFLAGS=-O3
CC=nvcc
OPT=-Wall


SRCS=$(wildcard *.c)
exe=$(SRCS:.c=.exe)

default: $(exe)
%.exe: %.c
	$(CC) $< $(CFLAGS) $(OPT) -o $@ 

clean: 
	rm -rf  $(exe)

run:
	./run.sh

send:
	rsync -vrh  --progress  --exclude '*.exe' . uly:/home/hnguruwe/async/

recv:
	rsync -vrh  --progress --include  '*.dat'   uly:/home/hnguruwe/async/

plot:
	@python plot.py

.PHONY: clean run plot send recv