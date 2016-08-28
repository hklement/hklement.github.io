.PHONY: spec

spec:
	coffee --compile js/ spec/
	JASMINE_CONFIG_PATH=spec/jasmine.yml rake jasmine:ci; make clean

clean:
	rm -f js/index.js
	rm -f js/util.js
	rm -f spec/*_spec.js

install:
	./install_dev_dependencies.sh

lint:
	coffeelint js/ spec/

minify:
	rm -f css/application.min.css
	cat css/*.css | cleancss --output css/application.min.css
	rm -f js/application.min.js
	coffee --compile js/
	cat js/*.js | uglifyjs --compress --mangle --output js/application.min.js
	make clean
