# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sony_camera_remote/version'

Gem::Specification.new do |spec|
  spec.name          = 'sony-camera-remote'
  spec.version       = SonyCameraRemote::VERSION
  spec.authors       = ['Nicholas E. Rabenau']
  spec.email         = ['nerab@gmx.at']
  spec.description   = %q{Provides a wrapper around to API for cameras that support the Sony [Camera Remote API](http://developer.sony.com/develop/cameras/).}
  spec.summary       = %q{Ruby API for the Sony Camera Remote API}
  spec.homepage      = "https://github.com/nerab/#{spec.name}"
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'json'
  spec.add_dependency 'require_all'
  spec.add_dependency 'system-getifaddrs'
  spec.add_dependency 'httparty'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'vcr', '~> 2.8.0'
  spec.add_development_dependency 'webmock', '~> 1.17.1'
end
