# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'job_dependencies/version'

Gem::Specification.new do |spec|
  spec.name          = 'job_dependencies'
  spec.version       = JobDependencies::VERSION
  spec.authors       = ['Ankita Gupta']
  spec.email         = ['ankita.gupta@honestbee.com']

  spec.summary       = 'Allows creation of job dependencies'
  spec.description   = 'Allows setting of dependenices between jobs and setting rules for dependency resolution'
  spec.homepage      = 'https://github.com/honestbee/job_dependencies'
  spec.license       = 'MIT'

  spec.files         = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency "activerecord", ['>= 4.0', '< 5.2']
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
end
