[[ $(which ruby) ]] || brew install ruby
[[ $(which bundle) ]] || gem install bundler
bundle install
[[ $(which node) ]] || brew install nodejs
npm install
