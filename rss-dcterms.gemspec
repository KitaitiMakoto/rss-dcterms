# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["KITAITI Makoto"]
  gem.email         = ["KitaitiMakoto@gmail.com"]
  gem.description   = %q{Enable standard bundled RSS library parse and make feeds using DCMI Metadata Terms}
  gem.summary       = %q{DCTERMS support for standard bundled RSS library}
  gem.homepage      = "https://gitorious.org/rss/dcterms"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rss-dcterms"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.1'

  gem.add_development_dependency 'test-unit'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-doc'
  gem.add_development_dependency 'yard'
end
