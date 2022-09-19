package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strings"
)

var Version = "dev"

func sortMap(data map[string]interface{}) map[string]interface{} {
	result := make(map[string]interface{})
	for k, v := range data {
		result[k] = sortJSON(v)
	}
	return result
}

func sortArray(data []interface{}) []interface{} {
	result := make([]interface{}, len(data))
	sort.Slice(data, func(i, j int) bool {
		return fmt.Sprintf("%v", data[i]) < fmt.Sprintf("%v", data[j])
	})
	for i, v := range data {
		result[i] = sortJSON(v)
	}
	return result
}

func sortJSON(data interface{}) interface{} {
	switch v := data.(type) {
	case map[string]interface{}:
		return sortMap(v)
	case []interface{}:
		return sortArray(v)
	default:
		return v
	}
}

func printUsage() {
	fmt.Println("Usage: jds [file]")
	fmt.Println("If no file is specified, reads from stdin.")
	fmt.Println("Version:", Version)
}

func main() {
	var infile string
	if len(os.Args) > 1 {
		infile = os.Args[1]
	} else {
		infile = "-"
	}
	if infile == "-h" || infile == "--help" {
		printUsage()
		return
	}
	var input []byte
	var err error
	if infile == "-" {
		input, err = ioutil.ReadAll(os.Stdin)
	} else {
		input, err = ioutil.ReadFile(infile)
	}
	if err != nil {
		log.Fatal(err)
	}
	if strings.EqualFold(string(input), "null") || len(input) == 0 || strings.TrimSpace(string(input)) == "" {
		fmt.Print(string(input))
		return
	}
	var data interface{}
	err = json.Unmarshal(input, &data)
	if err != nil {
		log.Fatal(err)
	}
	output, err := json.MarshalIndent(sortJSON(data), "", "  ")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Print(string(output))
}
