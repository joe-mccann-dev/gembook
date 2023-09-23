#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install && yarn install
bundle exec rails assets:precompile
rails assets:precompile
rails assets:clean
bundle exec rails db:migrate