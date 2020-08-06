package main

import (
	"fmt"
	"time"

	"github.com/fluent/fluent-logger-golang/fluent"
)

func main() {
	f, err := fluent.New(fluent.Config{
		FluentHost:   "fluentd-forwarder-ingress",
		WriteTimeout: time.Millisecond * 500,
		Async:        true,
		BufferLimit:  10,
	})
	if err != nil {
		fmt.Printf("error creating stream %s\n", err.Error())
		panic("exiting")
	}
	fmt.Println("Stream exists")
	for {
		m := map[string]string{
			"log":         "This is a test log from a golang application",
			"app_id":      "11111111-1111-1111-1111-111111111111",
			"instance_id": "1",
			"source_type": "APP",
		}

		err = f.PostWithTime("forwarded", time.Now(), m)
		if err != nil {
			fmt.Printf("error forwarding %s\n", err.Error())
		}
		fmt.Println("wrote to forwarder, sleeping")
		time.Sleep(time.Second)
	}
}
