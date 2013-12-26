
build:
	coffee -c -p src/sdo.coffee > sdo.js

dist: build
	uglifyjs sdo.js -o sdo.min.js -c -m

.PHONY: build dist