$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'weird/version'
Gem::Specification.new do |s|
 s.name        = "weird"
 s.version     = Weird::VERSION
 s.authors     = ["Daniel Vydra"]
 s.email       = ["usefulaccount@gmail.com"]

 s.summary     = "New Zealand IRD number checksum validation"
 s.description = "Checksum validation for New Zealand IRD numbers. See http://www.ird.govt.nz/how-to/irdnumbers/ for details of what an IRD is."
 s.homepage    = "http://github.com/dvydra/weird"
 s.files       = Dir.glob("lib/**/*.rb")

 s.add_development_dependency "rspec", "~>2.7"
end
