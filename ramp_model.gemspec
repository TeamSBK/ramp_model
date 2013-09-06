# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ramp_model/version'

Gem::Specification.new do |spec|
  spec.name          = "ramp_model"
  spec.version       = RampModel::VERSION
  spec.authors       = ["Jaemar Joseph Ramos"]
  spec.email         = ["jaemar.ramos@gmail.com"]
  spec.description   = %q{ramp-model is a web-based model representation app. It provides WYSIWYG platform for bootstraping the data architecture of your next awesome app then gracefully provides you with the next step.}
  spec.summary       = %q{ramp-model is a web-based model representation app.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "rest-client"
end
