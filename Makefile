.PHONY: setup test run build

setup:
	bundle install --path vendor/bundle

test:
	bundle exec rspec

run:
	bundle exec ruby bin/dependencies-synchronizer $(ARGS)

build:
	gem build dependencies_synchronizer.gemspec
