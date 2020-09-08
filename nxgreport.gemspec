Gem::Specification.new do |spec|
    spec.name        = 'nxgreport'
    spec.version     = '0.7.0'
    spec.date        = '2020-09-06'
    spec.summary     = "Next Gen Report"
    spec.description = "A simple light weighted gem to generate a beautiful emailable test report. \n\nIt displays a single view where tests (total, pass, fail) are grouped by functionality. The result is a single static HTML file with an option to switch between dark & light modes."
    spec.authors     = ["Balabharathi Jayaraman"]
    spec.email       = 'balabharathi.jayaraman@gmail.com'
    spec.files       = ["lib/nxgreport.rb"]
    spec.homepage    = 'https://rubygemspec.org/gems/nxgreport'
    spec.license     = 'MIT'
    spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/balabharathijayaraman/nxgreport"
    spec.metadata["changelog_uri"] = "https://github.com/balabharathijayaraman/nxgreport/blob/master/CHANGELOG.md"
end