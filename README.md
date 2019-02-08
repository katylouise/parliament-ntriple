# Parliament::NTriple

[parliament-ntriple](http://rubygems.org/gems/parliament-ntriple) is a gem created by the [Parliamentary Digital Service](https://www.parliament.uk/mps-lords-and-offices/offices/bicameral/parliamentary-digital-service/) to allow processing of n-triple data from parliamentary APIs.  This gem is effectively an extension of our [parliament-ruby](http://rubygems.org/gems/parliament-ruby) gem.

> **NOTE:** This gem is in active development and is likely to change at short notice. It is not recommended that you use this in any production environment.

## Requirements
[parliament-ntriple](http://github.com/ukparliament/parliament-ntriple) requires the following:
* [Ruby](https://www.ruby-lang.org/en/)
* [Bundler](http://http://bundler.io/)

## Installation

```bash
gem 'parliament-ntriple'
```

## Usage

This gem's main function is to process n-triple data from parliamentary APIs.

> **Note:** Comprehensive class documentation can be found on [rubydocs](http://www.rubydoc.info/github/ukparliament/parliament-ntriple/master/file/README.md).

## Getting Started with Development
To clone the repository and set up the dependencies, run the following:
```bash
git clone https://github.com/ukparliament/parliament-ntriple.git
cd parliament-ntriple
bundle install
```

### Running the tests
We use [RSpec](http://rspec.info/) as our testing framework and tests can be run using:
```bash
bundle exec rake
```

## Contributing
If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

1. Fork the repository
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Ensure your changes are tested using [Rspec](http://rspec.info/)
1. Create a new Pull Request
