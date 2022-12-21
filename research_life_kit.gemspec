# frozen_string_literal: true

require_relative "lib/research_life_kit/version"

Gem::Specification.new do |spec|
  spec.name = "research_life_kit"
  spec.version = ResearchLifeKit::VERSION
  spec.authors = ["HanNayAung"]
  spec.email = ["hus50851@kwansei.ac.jp"]

  spec.summary = "Help Researchers Life"
  spec.description = "Help Researchers Life"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "watir"
  spec.add_development_dependency "webdrivers"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "watir-scroll"

  spec.add_development_dependency "optparse"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
