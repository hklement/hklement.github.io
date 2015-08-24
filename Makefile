compile:
	coffee --compile js/*.coffee

minify: compile
	rm -f css/application.min.css
	cat css/*.css | cleancss --output css/application.min.css
	rm -f js/application.min.js
	cat js/*.js | uglifyjs --compress --mangle --output js/application.min.js
	rm -f js/util.js

install:
	./install_dev_dependencies.sh
