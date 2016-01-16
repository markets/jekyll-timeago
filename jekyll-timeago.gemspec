# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-timeago/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-timeago"
  spec.version       = Jekyll::Timeago::VERSION
  spec.authors       = ["markets"]
  spec.email         = ["srmarc.ai@gmail.com"]
  spec.description   = "Custom timeago filter for Jekyll (Liquid Filter and Tag). Localization and futures supported."
  spec.summary       = "Custom timeago filter for Jekyll (Liquid Filter and Tag). Localization and futures supported."
  spec.homepage      = "https://github.com/markets/jekyll-timeago"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "jekyll", ">= 1.5"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "appraisal"
end
