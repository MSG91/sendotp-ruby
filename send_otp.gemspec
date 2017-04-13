# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'send_otp/version'

Gem::Specification.new do |spec|
  spec.name          = "send_otp"
  spec.version       = SendOtp::VERSION
  spec.authors       = ["Utkarsh"]
  spec.email         = ["utkarsh@walkover.in"]

  spec.summary       = %q{This gem allows to send otp, verify otp and retry otp}
  spec.description   = %q{This gem enables sendOTP and allows you to send OTP}
  spec.homepage      = "https://sendotp.msg91.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
