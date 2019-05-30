require './lib/jekyll-timeago/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-timeago"
  spec.version       = Jekyll::Timeago::VERSION
  spec.authors       = ["markets"]
  spec.email         = ["srmarc.ai@gmail.com"]
  spec.summary       = "A date helper to compute distance of dates in words."
  spec.description   = "A Ruby library to compute distance of dates in words. Originally built for Jekyll, as a Liquid extension. It also supports localization and futures."
  spec.homepage      = "https://github.com/markets/jekyll-timeago"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mini_i18n", '>= 0.8.0'

  spec.add_development_dependency "jekyll", ">= 1.5"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "appraisal"
end
