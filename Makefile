
build:
	./node_modules/.bin/coffee -c -p src/sdo.coffee > sdo.js
	./node_modules/.bin/coffee -c -p src/hash.coffee > hash.js

dist: build
	./node_modules/.bin/uglifyjs sdo.js -o sdo.min.js -c -m
	./node_modules/.bin/uglifyjs hash.js -o hash.min.js -c -m

.PHONY: build dist