VERSION := $(shell git describe --tags --always)
BUILD := go build -v -ldflags "-s -w -X main.Version=$(VERSION)"

BINARY = check_fritz

.PHONY : all clean build test

all: build test

test:
	go test -v ./...

clean:
	rm -rf build/

build:
	mkdir -p build
	GOOS=freebsd GOARCH=amd64 $(BUILD) -o build/$(BINARY).freebsd.amd64 ./cmd/check_fritz
	cd build; sha256 $(BINARY).freebsd.amd64 > $(BINARY).freebsd.amd64.sha256

test-checksum:
	cd build; sha256 -c $(BINARY).freebsd.amd64.sha256
