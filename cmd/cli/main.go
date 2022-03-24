package main

import (
	"log"
	"os"

	"github.com/DanielTitkov/rhymecurse/internal/configs"
)

func main() {
	configPath := "./configs/cli.yml"
	log.Println("loading config from "+configPath, "")

	_, err := configs.ReadConfigs(configPath)
	if err != nil {
		log.Fatal("failed to load config", err)
	}
	log.Println("loaded config")

	args := os.Args[1:]
	if len(args) < 1 {
		log.Fatal("token is not provided")
	}
	token := args[0]
	log.Println("token:", token)
}
