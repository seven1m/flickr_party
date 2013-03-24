require 'ostruct'

class FlickrParty
  class Photo
    def initialize(hash)
      @hash = hash
    end

    def url(size=nil)
      if %w(m s t b).include?(size)
        "http://farm#{@hash['farm']}.static.flickr.com/#{@hash['server']}/#{@hash['id']}_#{@hash['secret']}_#{size}.jpg"
      elsif size == 'o' and @hash['originalsecret'] and @hash['originalformat']
        "http://farm#{@hash['farm']}.static.flickr.com/#{@hash['server']}/#{@hash['id']}_#{@hash['originalsecret']}_#{size}.#{@hash['originalformat']}"
      elsif size.nil? or size == '-'
        "http://farm#{@hash['farm']}.static.flickr.com/#{@hash['server']}/#{@hash['id']}_#{@hash['secret']}.jpg"
      else
        raise PhotoURLError, "Invalid size or missing keys in @hash. Valid sizes are m, s, t, b, o, and nil. For original (o) size, @hash must contain both 'originalsecret' and 'originalformat'."
      end
    end

    def to_h
      @hash
    end

  end
end
