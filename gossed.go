package main

import (
	"net/http"
	"bufio"
	"os"
	"flag"
	"log"
	"strconv"

	"github.com/alexandrevicenzi/go-sse"
)

func main() {
	port := flag.Int("port", 3000, "port on which events will be sent")
	flag.Parse()
	
	s := sse.NewServer(&sse.Options{
		Headers: map[string]string {
			"Access-Control-Allow-Origin": "*",
			"Access-Control-Allow-Methods": "GET, OPTIONS",
			"Access-Control-Allow-Headers": "Keep-Alive,X-Requested-With,Cache-Control,Content-Type,Last-Event-ID",
		},
	})

	defer s.Shutdown()

	http.Handle("/", s)

	go func () {
		scanner := bufio.NewScanner(os.Stdin)
		for scanner.Scan() {
			s.SendMessage("/", sse.SimpleMessage(scanner.Text()))
		}
	}()

	log.Println("Listening on port: " + strconv.Itoa(*port))
	http.ListenAndServe(":" + strconv.Itoa(*port), nil)
}
