Gem::Specification.new do |spec|
    spec.name        = 'nxgreport'
    spec.version     = '0.9.0'
    spec.date        = '2020-09-19'
    spec.summary     = "Next Gen Report"
    spec.description = "Generate a beautiful static test report."
    spec.authors     = ["Balabharathi Jayaraman"]
    spec.email       = 'balabharathi.jayaraman@gmail.com'
    spec.files       = ["lib/nxgreport.rb", 'lib/nxgcore.rb', "lib/nxgcss.rb"]
    spec.homepage    = 'https://rubygemspec.org/gems/nxgreport'
    spec.license     = 'MIT'
    spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/balabharathijayaraman/nxgreport"
    spec.metadata["changelog_uri"] = "https://github.com/balabharathijayaraman/nxgreport/blob/master/CHANGELOG.md"
end