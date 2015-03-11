# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'einstein-enum'
  gem.version       = EinsteinEnum::Version
  gem.licenses      = ['BSD']

  gem.authors = ['Colin T.A. Gray']
  gem.email   = ['colinta@gmail.com']
  gem.summary     = %{Swift's Enums are genius.  Especially in a language that doesn't suck.}
  gem.description = <<-DESC
Let's not kid ourselves: Swift didn't remove much of the tedium of iOS
development.  However, it introduced the best ENUM type that I've ever seen.
DESC

  gem.homepage    = 'https://github.com/colinta/einstein-enum'

  gem.files       = Dir.glob('lib/**/*.rb')
  gem.files      << 'README.md'
  gem.test_files  = Dir.glob('spec/**/*.rb')

  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec', '~> 2.11'
end
