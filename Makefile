minify:
	yuicompressor css/fontello.css -o css/fontello.min.css
	yuicompressor css/index.css -o css/index.min.css
	yuicompressor css/timeline.css -o css/timeline.min.css
	yuicompressor js/index.js -o js/index.min.js

install:
	brew update
	brew install yuicompressor
