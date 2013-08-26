require File.expand_path('../lib/serialport-server', __FILE__)

Gem::Specification.new do |spec|
  spec.name = 'serialport-server'
  spec.version = SerialportServer::VERSION
  spec.authors = 'Sho Hashimoto'
  spec.email = ['hashimoto@shokai.org']
  spec.summary  = "SerialPort Server makes your Device (Arduino, mbed...) WebServer."
  spec.description = spec.summary
  spec.homepage = "http://shokai.github.com/serialport-server"
  spec.license = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'serialport', '>= 1.0.4'
  spec.add_dependency 'eventmachine'
  spec.add_dependency 'eventmachine_httpserver'
  spec.add_dependency 'em-websocket'
  spec.add_dependency 'args_parser'
  spec.add_dependency 'json'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
