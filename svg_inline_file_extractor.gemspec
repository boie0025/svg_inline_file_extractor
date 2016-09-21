# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'svg_inline_file_extractor/version'

Gem::Specification.new do |spec|
  spec.name          = "svg-inline-file-extractor"
  spec.version       = SvgInlineFileExtractor::VERSION
  spec.authors       = ["Nic Boie"]
  spec.email         = ["boie0025@gmail.com"]

  spec.summary       = %q{Extract inline SVG base64 encoded images, and other inline files.}
  spec.homepage      = "https://github.com/boie0025/svg_inline_file_extractor"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0"
end
