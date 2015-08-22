# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clean_settings/version'

Gem::Specification.new do |spec|
  spec.name          = "clean_settings"
  spec.version       = CleanSettings::VERSION
  spec.authors       = ["Alexander Shlinchak"]
  spec.email         = ["ashlinchak@gmail.com"]

  spec.summary       = %q{Simple and clean settings for your Rails project.}
  spec.description   = %q{Storing global and object's settings in DB. Simple for using in Rails applicatons.}
  spec.homepage      = "https://github.com/ashlinchak/clean_settings"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("rails", [">= 4.0.0"])

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.10"
end
