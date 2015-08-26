clean:
	rm -f js/util.js
	rm -f spec/*_spec.js

compile:
	coffee --compile js/
	coffee --compile spec/

minify: compile
	rm -f css/application.min.css
	rm -f js/application.min.js
	cat css/*.css | cleancss --output css/application.min.css
	cat js/*.js | uglifyjs --compress --mangle --output js/application.min.js

install:
	./install_dev_dependencies.sh

spec: minify
	rake jasmine:ci JASMINE_CONFIG_PATH=spec/jasmine.yml; make clean
