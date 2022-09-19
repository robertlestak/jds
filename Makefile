VERSION=v0.0.1

.PHONY: bin
bin: bin/jds_darwin_x86_64 bin/jds_darwin_arm64 bin/jds_linux_x86_64 bin/jds_linux_arm bin/jds_linux_arm64 bin/jds_windows_x86_64.exe

bin/jds_darwin_x86_64:
	mkdir -p bin
	GOOS=darwin GOARCH=amd64 go build -ldflags="-X 'main.Version=$(VERSION)'" -o bin/jds_darwin_x86_64 cmd/jds/*.go
	openssl sha512 bin/jds_darwin_x86_64 > bin/jds_darwin_x86_64.sha512

bin/jds_darwin_arm64:
	mkdir -p bin
	GOOS=darwin GOARCH=arm64 go build -ldflags="-X 'main.Version=$(VERSION)'" -o bin/jds_darwin_arm64 cmd/jds/*.go
	openssl sha512 bin/jds_darwin_arm64 > bin/jds_darwin_arm64.sha512

bin/jds_linux_x86_64:
	mkdir -p bin
	GOOS=linux GOARCH=amd64 go build -ldflags="-X 'main.Version=$(VERSION)'" -o bin/jds_linux_x86_64 cmd/jds/*.go
	openssl sha512 bin/jds_linux_x86_64 > bin/jds_linux_x86_64.sha512

bin/jds_linux_arm:
	mkdir -p bin
	GOOS=linux GOARCH=arm go build -ldflags="-X 'main.Version=$(VERSION)'" -o bin/jds_linux_arm cmd/jds/*.go
	openssl sha512 bin/jds_linux_arm > bin/jds_linux_arm.sha512

bin/jds_linux_arm64:
	mkdir -p bin
	GOOS=linux GOARCH=arm64 go build -ldflags="-X 'main.Version=$(VERSION)'" -o bin/jds_linux_arm64 cmd/jds/*.go
	openssl sha512 bin/jds_linux_arm64 > bin/jds_linux_arm64.sha512

bin/jds_windows_x86_64.exe:
	mkdir -p bin
	GOOS=windows GOARCH=amd64 go build -ldflags="-X 'main.Version=$(VERSION)'" -o bin/jds_windows_x86_64.exe cmd/jds/*.go
	openssl sha512 bin/jds_windows_x86_64.exe > bin/jds_windows_x86_64.exe.sha512