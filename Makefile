CRYSTAL_BIN ?= $(shell which crystal)
DES_BIN ?= $(shell which des)
PREFIX ?= /usr/local

build:
	$(CRYSTAL_BIN) dep update
	$(CRYSTAL_BIN) build --release -o bin/des src/cli.cr $(CRFLAGS)

clean:
	rm -f ./bin/des

spec: build
	$(CRYSTAL_BIN) spec

install: build
	mkdir -p $(PREFIX)/bin
	cp ./bin/des $(PREFIX)/bin
	cp ./template/.desrc.yml $(HOME)
