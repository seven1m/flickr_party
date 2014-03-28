Gem::Specification.new do |s|
  s.name = "flickr_party"
  s.version = "0.4.0"
  s.author = "Tim Morgan"
  s.email = "tim@timmorgan.org"
  s.homepage = "http://github.com/seven1m/flickr_party"
  s.summary = "Lightweight wrapper for Flickr API using HTTParty"
  s.files = %w(README.markdown lib/flickr_party.rb lib/flickr_party/methods.rb lib/flickr_party/parser.rb lib/flickr_party/photo.rb)
  s.require_path = "lib"
  s.has_rdoc = false
  s.add_dependency("httparty")
end
