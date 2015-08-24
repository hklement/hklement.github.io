minify:
	cleancss css/fontello.css --output css/fontello.min.css
	cleancss css/index.css --output css/index.min.css
	cleancss css/timeline.css --output css/timeline.min.css
	uglifyjs js/index.js --compress --mangle --output js/index.min.js

install:
	./install_dev_dependencies.sh
