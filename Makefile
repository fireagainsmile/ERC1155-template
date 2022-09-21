# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.
# solc and abigen binary is required before running make commands

.PHONY: all test clean

all:
	solc --abi ./contracts/BaokuNFT.sol -o build
	abigen --abi ./build/BaokuNFT.abi --pkg main --out BaokuNFT.go

clean:
	rm -r -f ./build

test:
	truffle compile

