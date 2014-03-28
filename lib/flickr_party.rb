require 'rubygems'
require 'httparty'
require 'digest/md5'

require_relative 'flickr_party/methods'
require_relative 'flickr_party/photo'
require_relative 'flickr_party/parser'

class FlickrParty

  ENDPOINT = 'http://api.flickr.com/services/rest/'

  class UnknownMethodNameError < StandardError; end
  class PhotoURLError < StandardError; end

  include HTTParty
  format :xml
  parser FlickrParser

  attr_accessor :token

  def initialize(api_key, secret, method=nil, token=nil)
    @api_key = api_key
    @secret = secret
    @method = method
    @token = token
  end

  def method_missing(method_part, args={}, test=nil)
    full_method_name = concat_method(method_part)
    if is_full_method?(full_method_name)
      args = merge_args(args, full_method_name)
      post(args)
    else
      # not an API call -- return a chainable object
      self.class.new(@api_key, @secret, full_method_name, @token)
    end
  end

  def auth_url(perms='read', extra = nil)
    @frob = self.flickr.auth.getFrob['frob']
    sig = Digest::MD5.hexdigest("#{@secret}api_key#{@api_key}extra#{extra}frob#{@frob}perms#{perms}")
    "http://flickr.com/services/auth/?api_key=#{@api_key}&perms=#{perms}&frob=#{@frob}&api_sig=#{sig}&extra=#{extra}"
  end

  def complete_auth(frob='put_your_frob_here')
    @frob ||= frob
    @auth = self.flickr.auth.getToken('frob' => @frob)['auth']
    @token = @auth['token']
  end

private

  def post(args)
    self.class.post(ENDPOINT, :body => args).tap do |response|
      if Array === response['photos']
        response['photos'].map! do |photo_hash|
          Photo.new(photo_hash)
        end
      elsif Hash === response['photos']
        Photo.new(response['photos'])
      end
    end
  end

  def merge_args(arguments, method_name)
    self.class.stringify_hash_keys(arguments).tap do |args|
      args.merge!('api_key' => @api_key, 'method' => method_name.to_s)
      args.merge!('auth_token' => @token) if @token
      args.merge!('api_sig' => arg_signature(args))
    end
  end

  def arg_signature(args)
    args_to_s = args.sort.inject('') { |s, (k, v)| s += k.to_s + v.to_s }
    Digest::MD5.hexdigest(@secret.to_s + args_to_s)
  end

  def self.stringify_hash_keys(hash)
    hash.inject({}) do |options, (key, value)|
      options[key.to_s] = value
      options
    end
  end

end
