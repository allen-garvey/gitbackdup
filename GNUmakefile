SRC = $(shell find ./src -type f -name '*.d')

all: dev

dev:
	dmd $(SRC) -of./bin/gitbackdup -od./bin -unittest

release:
	dmd $(SRC) -of./bin/gitbackdup -od./bin -O -inline