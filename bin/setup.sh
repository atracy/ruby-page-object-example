#!/usr/bin/env bash
# set -e

# This script is a starting point to setup your application.
# Add necessary setup steps to this file.

echo "== Installing homebrew packages =="
brew update
brew tap homebrew/bundle
brew bundle

echo "== Installing ruby =="
rbenv install --skip-existing `cat .ruby-version`
rbenv local 2.4.1

echo "== Installing dependencies =="
gem update --system
gem install bundler --conservative
bundle install

echo "== Creating files to hold local environment variables =="
ruby ./bin/create_local_environment_variable_files_script.rb
