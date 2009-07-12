require 'rubygems'
require 'httparty'
require 'md5'

class Flickr

  ENDPOINT = 'http://api.flickr.com/services/rest/'
  
  class PhotoURLError < RuntimeError; end
  
  include HTTParty
  format :xml
  
  attr_accessor :token
  
  THIRD_LEVEL_METHODS = %w(add browse search delete create find echo login null)
  
  def initialize(api_key, secret, method=nil, token=nil)
    @api_key = api_key
    @secret = secret
    @method = method
    @token = token
  end
  
  def method_missing(method_name, args={}, test=nil)
    if @method.to_s.count('.') == 2 or method_name =~ /[A-Z]/ or THIRD_LEVEL_METHODS.include?(method_name)
      args.merge!('api_key' => @api_key, 'method' => @method + '.' + method_name.to_s, 'format' => 'rest')
      if @token
        args.merge!('auth_token' => @token)
      end
      args.merge!(:api_sig => MD5.hexdigest(@secret + args.to_a.sort.to_s))
      self.class.post(ENDPOINT, :body => args)
    else
      if @method
        method = @method + '.' + method_name.to_s
      else
        method = method_name.to_s
      end
      self.class.new(@api_key, @secret, method, @token)
    end
  end
  
  def auth_url(perms='read')
    @frob = self.flickr.auth.getFrob['rsp']['frob']
    sig = MD5.hexdigest("#{@secret}api_key#{@api_key}frob#{@frob}perms#{perms}")
    puts "http://flickr.com/services/auth/?api_key=#{@api_key}&perms=#{perms}&frob=#{@frob}&api_sig=#{sig}"
  end
  
  def complete_auth
    @auth = self.flickr.auth.getToken('frob' => @frob)['rsp']['auth']
    @token = @auth['token']
  end
  
  def photo_url(photo_hash, size=nil)
    if %w(m s t b).include?(size)
      "http://farm#{photo_hash['farm']}.static.flickr.com/#{photo_hash['server']}/#{photo_hash['id']}_#{photo_hash['secret']}_#{size}.jpg"
    elsif size == 'o' and photo_hash['originalsecret'] and photo_hash['originalformat']
      "http://farm#{photo_hash['farm']}.static.flickr.com/#{photo_hash['server']}/#{photo_hash['id']}_#{photo_hash['originalsecret']}_#{size}.#{photo_hash['originalformat']}"
    elsif size.nil? or size == '-'
      "http://farm#{photo_hash['farm']}.static.flickr.com/#{photo_hash['server']}/#{photo_hash['id']}_#{photo_hash['secret']}.jpg"
    else
      raise PhotoURLError, "Invalid size or missing keys in photo_hash. Valid sizes are m, s, t, b, o, and nil. For original (o) size, photo_hash must contain both 'originalsecret' and 'originalformat'."
    end
  end
  
end