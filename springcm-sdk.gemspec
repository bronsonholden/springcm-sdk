
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "springcm-sdk/version"

Gem::Specification.new do |spec|
  spec.name          = "springcm-sdk"
  spec.version       = Springcm::VERSION
  spec.authors       = ["Paul Holden"]
  spec.email         = ["pholden@stria.com"]

  spec.summary       = %q{A library for working with the SpringCM REST API.}
  spec.description   = %q{A library for working with the SpringCM REST API and associated objects in Ruby applications.}
  spec.homepage      = "https://github.com/paulholden2/springcm-sdk"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/paulholden2/springcm-sdk"
    spec.metadata["documentation_uri"] = "https://rubydoc.info/github/paulholden2/springcm-sdk/#{Springcm::VERSION}"
    spec.metadata["changelog_uri"] = "https://github.com/paulholden2/springcm-sdk/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = ["springcm"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 1.0.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sinatra", "~> 2.0"
  spec.add_development_dependency "webmock", "~> 3.6"
  spec.add_development_dependency "simplecov", "~> 0.17"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "uuid", "~> 2.3"
end
