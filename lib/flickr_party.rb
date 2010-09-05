require 'rubygems'
require 'httparty'
require 'digest/md5'

class FlickrParty

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
    if @method.to_s.count('.') == 2 or method_name.to_s =~ /[A-Z]/ or THIRD_LEVEL_METHODS.include?(method_name.to_s)
      args = self.class.stringify_hash_keys(args)
      args.merge!('api_key' => @api_key, 'method' => @method + '.' + method_name.to_s)
      if @token
        args.merge!('auth_token' => @token)
      end
      args_to_s = ""
      args.sort.each{|a| args_to_s += a[0].to_s + a[1].to_s }
      sig = Digest::MD5.hexdigest(@secret.to_s + args_to_s)
      args.merge!(:api_sig => sig)
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
    sig = Digest::MD5.hexdigest("#{@secret}api_key#{@api_key}frob#{@frob}perms#{perms}")
    "http://flickr.com/services/auth/?api_key=#{@api_key}&perms=#{perms}&frob=#{@frob}&api_sig=#{sig}"
  end
  
  def complete_auth(frob='put_your_frob_here')
    @frob ||= frob
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
  
  def self.stringify_hash_keys(hash)
    hash.inject({}) do |options, (key, value)|
      options[key.to_s] = value
      options
    end
  end
  
end
