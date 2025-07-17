# dependencies_synchronizer.gemspec

Gem::Specification.new do |spec|
  spec.name          = 'dependencies_synchronizer'
  spec.version       = '0.1.2'
  spec.authors       = ['Dielson Sales']
  spec.email         = ['dielsonscarvalho@gmail.com']

  spec.summary       = 'Sync your iOS module’s dependencies with the main app.'
  spec.description   = 'A CLI tool to automatically update Podfile, Package.swift, and .podspec files in your iOS modules.'
  spec.homepage      = 'https://github.com/dielsonsales/dependencies-synchronizer'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb'] + ['bin/dependencies-synchronizer']
  spec.executables   = ['dependencies-synchronizer']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.13'
end
