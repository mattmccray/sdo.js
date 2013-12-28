
build:
	@echo "/* simple data objects - http://github.com/darthapo/sdo.js */" > sdo.js
	
	./node_modules/.bin/coffee -c -j sdo.js src/hash.coffee src/list.coffee

dist: build
	./node_modules/.bin/uglifyjs sdo.js -o sdo.min.js -c -m --preamble "/* simple data objects - http://github.com/darthapo/sdo.js */"

.PHONY: build dist