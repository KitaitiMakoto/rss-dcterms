# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rss/dcterms/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["KITAITI Makoto"]
  gem.email         = ["KitaitiMakoto@gmail.com"]
  gem.description   = %q{Enables standard bundled RSS library parse and make feeds including DCMI(Dublin Core Metadata Initiative) Metadata Terms}
  gem.summary       = %q{DCTerms support for standard bundled RSS library}
  gem.homepage      = "http://rss-ext.rubyforge.org/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rss-dcterms"
  gem.require_paths = ["lib"]
  gem.version       = RSS::DCTerms::VERSION

  gem.add_development_dependency 'test-unit'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-doc'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'redcarpet'
end
