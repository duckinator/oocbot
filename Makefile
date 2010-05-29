OOC?=rock
OOCFLAGS=-noclean

all: oocbot

oocbot:
	${OOC} ${OOCFLAGS} oocbot.ooc -o=oocbot
  
clean:
	rm -rf oocbot .libs rock_tmp spry

.PHONY: all clean oocbot
