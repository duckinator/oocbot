OOC=ooc
OOCFLAGS=-driver=sequence -noclean

all: oocbot

oocbot:
	${OOC} ${OOCFLAGS} $(shell find . -name "*.ooc") -o=oocbot
  
clean:
	rm oocbot

.PHONY: all clean oocbot
