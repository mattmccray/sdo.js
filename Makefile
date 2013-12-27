
build:
	./node_modules/.bin/coffee -c -p src/sdo.coffee > sdo.js

dist: build
	./node_modules/.bin/uglifyjs sdo.js -o sdo.min.js -c -m

.PHONY: build dist