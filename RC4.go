// RC4 Encrypter by Pedro F. Albanese
package main

import (
	"crypto/rc4"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
)

var (
	key    = flag.String("k", "", "128-bit key to Encrypt/Decrypt.")
)

func main() {
	flag.Parse()

	if len(os.Args) < 2 || *key == "" {
		fmt.Println("Usage of", os.Args[0]+":")
		flag.PrintDefaults()
		os.Exit(1)
	}

	var err error
	ciph, _ := rc4.NewCipher([]byte(*key))
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
