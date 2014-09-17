Gem::Specification.new do |s|
  s.name = 'rexle-builder'
  s.version = '0.1.10'
  s.summary = 'rexle-builder'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb'] 
  s.signing_key = '../privatekeys/rexle-builder.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/rexle-builder'
  s.required_ruby_version = '>= 2.1.2'
end
