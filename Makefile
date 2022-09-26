.PHONY: test clean

build:
	mkdir -p functions
	go get ./...
	go build -o ./functions/ ./...

netlify:
	mkdir -p functions
	go get ./...
	go install ./...

test:
	LICHESS_BOT=honeybadger-bot go test ./... -v

clean:
	rm -f functions/*
