require_relative 'lib/nxgreport/version'

Gem::Specification.new do |spec|
  spec.name          = "nxgreport"
  spec.version       = Nxgreport::VERSION
  spec.authors       = ["Balabharathi Jayaraman"]
  spec.email         = ["balabharathi.jayaraman@gmail.com"]
  spec.summary       = "Next Gen Report"
  spec.description   = "Generate a beautiful static test report."
  spec.homepage      = 'https://rubygemspec.org/gems/nxgreport'
  spec.license       = "MIT"
  spec.files         = ['lib/nxgreport/version.rb', 'lib/nxgreport.rb', 'lib/nxgreport/nxgcore.rb', 'lib/nxgreport/nxgcss.rb', 'lib/nxgreport/nxgjs.rb', 'lib/nxgreport/nxghtml.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/iambalabharathi/nxgreport-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/iambalabharathi/nxgreport-ruby/blob/master/CHANGELOG.md"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "test-unit"
end
