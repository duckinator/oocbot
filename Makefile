OC?=rock
#OCFLAGS=-noclean

all: oocbot

oocbot:
	${OC} ${OCFLAGS} oocbot.ooc -o=oocbot
  
clean:
	rm -rf oocbot .libs ${OC}_tmp

.PHONY: all clean oocbot
