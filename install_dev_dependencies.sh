[[ $(which ruby) ]] || (brew install ruby && gem install bundler)
bundle install
[[ $(which node) ]] || brew install nodejs
npm install
