CRYSTAL_BIN ?= $(shell which crystal)
DES_BIN ?= $(shell which des)
PREFIX ?= /usr/local
OUTPUT_BIN ?= bin/des
TAR_DIR ?= bin/tar
RC_FILE_TEMPLATE ?= ./template/.desrc.yml
VERSION ?= 0.1.0
TAR_GZ_FILE ?= des-$(VERSION)-darwin-x86_64.tar.gz

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

tar: build
	mkdir -p $(TAR_DIR)
	cp $(OUTPUT_BIN) $(TAR_DIR)
	cp $(RC_FILE_TEMPLATE) $(TAR_DIR)
	cp README.md $(TAR_DIR)
	cp LICENSE $(TAR_DIR)
	tar zcvf bin/$(TAR_GZ_FILE) $(TAR_DIR)
