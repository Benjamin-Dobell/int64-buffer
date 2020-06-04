#!/usr/bin/env bash -c make

SRC=./dist/int64-buffer.js
TESTS=*.json ./test/*.js
DIST=./dist
JSDEST=./dist/int64-buffer.min.js
JSGZIP=./dist/int64-buffer.min.js.gz

all: $(JSGZIP) test

clean:
	rm -fr $(JSDEST)

$(DIST):
	mkdir -p $(DIST)

$(SRC): $(DIST)
	./node_modules/.bin/rollup -c

$(JSDEST): $(SRC) $(DIST)
	./node_modules/.bin/uglifyjs $(SRC) -c -m -o $(JSDEST)

$(JSGZIP): $(JSDEST)
	gzip -9 < $(JSDEST) > $(JSGZIP)
	ls -l $(JSDEST) $(JSGZIP)

test:
	@if [ "x$(BROWSER)" = "x" ]; then make test-node; else make test-browser; fi

test-node: mocha

mocha:
	./node_modules/.bin/mocha -R spec $(TESTS)

.PHONY: all clean test mocha
