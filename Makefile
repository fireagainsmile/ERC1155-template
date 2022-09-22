# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.
# solc and abigen binary is required before running make commands

.PHONY: all test clean

all: clean
	solc --abi ./contracts/BaokuNFT.sol -o build
	solc --bin ./contracts/BaokuNFT.sol -o bin
	abigen --abi ./build/BaokuNFT.abi --bin ./bin/BaokuNFT.bin --pkg contracts --out ./src/contracts/BaokuNFT.go

clean:
	rm -r -f ./build
	rm -r -f ./bin

test:
	truffle compile

