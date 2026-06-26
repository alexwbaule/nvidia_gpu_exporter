BINARY  := nvidia_gpu_exporter
CMD     := ./cmd/nvidia_gpu_exporter
LDFLAGS := -s -w

.PHONY: build build-linux build-windows test lint fmt release clean

build:
	CGO_ENABLED=0 go build -ldflags="$(LDFLAGS)" -o $(BINARY) $(CMD)

build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="$(LDFLAGS)" -o $(BINARY) $(CMD)

build-windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags="$(LDFLAGS)" -o $(BINARY).exe $(CMD)

test:
	go test ./...

lint:
	go mod tidy --diff
	golangci-lint run ./...
	markdownlint **/*.md
	shellcheck **/*.sh
	goreleaser check

fmt:
	go mod tidy
	go fix ./...
	golangci-lint run --fix ./...
	golangci-lint fmt ./...

release:
	goreleaser release --clean

clean:
	rm -f $(BINARY) $(BINARY).exe
