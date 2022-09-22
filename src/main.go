package main

import (
	"context"
	"fmt"
	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/crypto"
	"log"
	"math/big"
	"crypto/ecdsa"
	baokuNFT "github.com/fireagainsmile/ERC1155-template/src/contracts"
)

const (
	nodeUrl = ""
	privateKey = ""
)

func main()  {
	client, err := ethclient.Dial(nodeUrl)
	if err != nil {
		panic(err)
	}

	privateKey, err := crypto.HexToECDSA(privateKey)
	if err != nil {
		panic(err)
	}


	publicKey := privateKey.PublicKey
	publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
	if !ok {
		log.Fatal("cannot assert type: publicKey is not of type *ecdsa.PublicKey")
	}

	fromAddress := crypto.PubkeyToAddress(*publicKeyECDSA)


	nonce, err := client.PendingNonceAt(context.Background(), fromAddress)
	if err !=nil {
		panic(err)
	}

	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	chainId, err := client.ChainID(context.Background())
	if err != nil {
		panic(err)
	}

	auth, err := bind.NewKeyedTransactorWithChainID(privateKey, chainId)
	if err != nil {
		panic(err)
	}
	auth.Nonce = big.NewInt(int64(nonce))
	auth.From = fromAddress
	auth.GasPrice = gasPrice
	auth.NoSend = true

	_, tx, _, err := baokuNFT.DeployContracts(auth, client, "")

	msg := ethereum.CallMsg{From: fromAddress, To: nil, GasPrice: gasPrice, Value: big.NewInt(0), Data: tx.Data()}
	gasLimit, err := client.EstimateGas(context.Background(), msg)
	fmt.Println("etsimated gas limit:", gasLimit)


}
