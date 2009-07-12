Gem::Specification.new do |s|
  s.name = "flickr"
  s.version = "0.1.0"
  s.author = "Tim Morgan"
  s.email = "tim@timmorgan.org"
  s.homepage = "http://github.com/seven1m/flickr"
  s.summary = "Lightweight wrapper for Flickr API"
  s.files = %w(README.markdown lib/flickr.rb)
  s.require_path = "lib"
  s.has_rdoc = false
  s.add_dependency("httparty")
end
