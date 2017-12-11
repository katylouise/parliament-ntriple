# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parliament/ntriple/version'

Gem::Specification.new do |spec|
  spec.name          = 'parliament-ntriple'
  spec.version       = Parliament::NTriple::VERSION
  spec.authors       = ['Rebecca Appleyard']
  spec.email         = ['rklappleyard@gmail.com']

  spec.summary       = %q{Parliamentary NTriple response builder}
  spec.description   = %q{Parliamentary NTriple response builder}
  spec.homepage      = 'http://github.com/ukparliament/parliament_ntriple'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'grom', '~> 0.5'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.51'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.3'
  spec.add_development_dependency 'parliament-grom-decorators', '~> 0.14'
  spec.add_development_dependency 'parliament-ruby', '~> 0.10'
end
