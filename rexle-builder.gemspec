Gem::Specification.new do |s|
  s.name = 'rexle-builder'
  s.version = '1.0.2'
  s.summary = 'Generates XML, by producing an array of raw XML ' + 
      'elements which can parsed by the Rexle gem.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/rexle-builder.rb'] 
  s.signing_key = '../privatekeys/rexle-builder.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/rexle-builder'
  s.required_ruby_version = '>= 2.1.2'
end
