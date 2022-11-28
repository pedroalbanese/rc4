// RC4 Ecrypter by Pedro F. Albanese
package main

import (
	"crypto/rand"
	"crypto/rc4"
	"crypto/sha256"
	"encoding/hex"
	"flag"
	"fmt"
	"golang.org/x/crypto/pbkdf2"
	"io"
	"log"
	"os"
)

var (
	derive = flag.Bool("d", false, "Derive password-based key.")
	iter   = flag.Int("i", 1024, "Iterations. (for PBKDF2)")
	key    = flag.String("k", "", "128-bit key to Encrypt/Decrypt.")
	pbkdf  = flag.String("p", "", "PBKDF2.")
	random = flag.Bool("r", false, "Generate random 128-bit cryptographic key.")
	salt   = flag.String("s", "", "Salt. (for PBKDF2)")
)

func main() {
	flag.Parse()

	if len(os.Args) < 2 {
		fmt.Println("Usage of", os.Args[0]+":")
		flag.PrintDefaults()
		os.Exit(1)
	}

	if *derive == true {
		prvRaw := pbkdf2.Key([]byte(*pbkdf), []byte(*salt), *iter, 32, sha256.New)
		fmt.Println(hex.EncodeToString(prvRaw))
		os.Exit(1)
	}

	if *random == true {
		var key []byte
		var err error
		key = make([]byte, 32)
		_, err = io.ReadFull(rand.Reader, key)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println(hex.EncodeToString(key))
		os.Exit(0)
	}

	var keyHex string
	var prvRaw []byte
	if *pbkdf != "" {
		prvRaw = pbkdf2.Key([]byte(*pbkdf), []byte(*salt), *iter, 32, sha256.New)
		keyHex = hex.EncodeToString(prvRaw)
	} else {
		keyHex = *key
	}
	var key []byte
	var err error
	if keyHex == "" {
		key = make([]byte, 32)
		_, err = io.ReadFull(rand.Reader, key)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Fprintln(os.Stderr, "Key=", hex.EncodeToString(key))
	} else {
		key, err = hex.DecodeString(keyHex)
		if err != nil {
			log.Fatal(err)
		}
		if len(key) != 32 {
			log.Fatal(err)
		}
	}
	ciph, _ := rc4.NewCipher(key)
	buf := make([]byte, 64*1<<10)
	var n int
	for {
		n, err = os.Stdin.Read(buf)
		if err != nil && err != io.EOF {
			log.Fatal(err)
		}
		ciph.XORKeyStream(buf[:n], buf[:n])
		if _, err := os.Stdout.Write(buf[:n]); err != nil {
			log.Fatal(err)
		}
		if err == io.EOF {
			break
		}
	}
	os.Exit(0)
}
