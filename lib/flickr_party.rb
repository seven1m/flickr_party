require 'rubygems'
require 'httparty'
require 'digest/md5'

require_relative 'flickr_party/photo'

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
      response = self.class.post(ENDPOINT, :body => args)
      if response.has_key?('rsp') and response['rsp'].has_key?('photos') and response['rsp']['photos'].has_key?('photo')
        photos = response['rsp']['photos']['photo']
        photos.each_with_index do |photo_hash, index|
          photos[index] = Photo.new(photo_hash)
        end
      end
      response
    else
      if @method
        method = @method + '.' + method_name.to_s
      else
        method = method_name.to_s
      end
      self.class.new(@api_key, @secret, method, @token)
    end
  end
  
  def auth_url(perms='read', extra = nil)
    @frob = self.flickr.auth.getFrob['rsp']['frob']
    sig = Digest::MD5.hexdigest("#{@secret}api_key#{@api_key}extra#{extra}frob#{@frob}perms#{perms}")
    "http://flickr.com/services/auth/?api_key=#{@api_key}&perms=#{perms}&frob=#{@frob}&api_sig=#{sig}&extra=#{extra}"
  end
  
  def complete_auth(frob='put_your_frob_here')
    @frob ||= frob
    @auth = self.flickr.auth.getToken('frob' => @frob)['rsp']['auth']
    @token = @auth['token']
  end

  def self.stringify_hash_keys(hash)
    hash.inject({}) do |options, (key, value)|
      options[key.to_s] = value
      options
    end
  end
  
end
