CRYSTAL_BIN ?= $(shell which crystal)
DES_BIN ?= $(shell which des)
PREFIX ?= /usr/local
OUTPUT_BIN ?= bin/des
TAR_DIR ?= bin/des
RC_FILE_TEMPLATE ?= ./template/.desrc.yml
VERSION ?= 0.1.0
TAR_GZ_FILE_NAME ?= des-$(VERSION)-darwin-x86_64.tar.gz

build:
	$(CRYSTAL_BIN) dep update
	$(CRYSTAL_BIN) build --release -o $(OUTPUT_BIN) src/cli.cr $(CRFLAGS)

clean:
	rm -f ./bin/des

spec: build
	$(CRYSTAL_BIN) spec

install: build
	mkdir -p $(PREFIX)/bin
	cp ./bin/des $(PREFIX)/bin
	cp ./template/.desrc.yml $(HOME)

tar:
	rm -rf ./bin/*
	$(MAKE) build
	mv $(OUTPUT_BIN) $(OUTPUT_BIN)_bk
	mkdir -p $(TAR_DIR)
	cp $(OUTPUT_BIN)_bk $(TAR_DIR)/des
	cp $(RC_FILE_TEMPLATE) $(TAR_DIR)
	cp README.md $(TAR_DIR)
	cp LICENSE $(TAR_DIR)
	cd bin && tar zcvf $(TAR_GZ_FILE_NAME) des
