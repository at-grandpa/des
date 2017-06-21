CRYSTAL_BIN ?= $(shell which crystal)
DES_BIN ?= $(shell which des)
PREFIX ?= /usr/local
OUTPUT_BIN ?= bin/des
TAR_DIR ?= bin/des
VERSION ?= 0.1.0
TAR_GZ_FILE_NAME ?= des-$(VERSION)-darwin-x86_64.tar.gz

build:
	rm -rf ./bin/*
	$(CRYSTAL_BIN) dep update
	$(CRYSTAL_BIN) build --release -o $(OUTPUT_BIN) src/cli.cr $(CRFLAGS)

clean:
	rm -f ./bin/des

spec: build
	$(CRYSTAL_BIN) spec

install: build
	mkdir -p $(PREFIX)/bin
	cp ./bin/des $(PREFIX)/bin

tar:
	rm -rf ./bin/*
	$(MAKE) build
	mv $(OUTPUT_BIN) $(OUTPUT_BIN)_bin
	mkdir -p $(TAR_DIR)
	cp $(OUTPUT_BIN)_bin $(TAR_DIR)/des
	cp README.md $(TAR_DIR)
	cp LICENSE $(TAR_DIR)
	cd bin && tar zcvf $(TAR_GZ_FILE_NAME) des
