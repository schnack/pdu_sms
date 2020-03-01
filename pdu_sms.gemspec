# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pdu_sms/version'

Gem::Specification.new do |spec|
  spec.name          = "pdu_sms"
  spec.version       = PduSms::VERSION
  spec.authors       = ["Mikhail Stolyarov"]
  spec.email         = ["schnack.desu@gmail.com"]
  spec.license       = "MTI"
  spec.summary       = %q{PDU SMS coding and decoding library}
  spec.description   = %q{PDU SMS coding and decoding library}
  spec.homepage      = "https://github.com/schnack/pdu_sms"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
