.PHONY: all clean install update build test coverage format

all: clean install update format build test

clean:
	forge clean

install:
	forge install

update:
	forge update

build:
	forge build

test:
	forge test

coverage:
	forge coverage --report summary

format:
	forge fmt
