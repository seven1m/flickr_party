Flickr Party
============

Wrapper for the Flickr API, with real application authentication, using HTTParty.

About
-----

This piece of code uses HTTParty for its magic. All Flickr methods should
be supported, but you'll still need to reference the Flickr API docs heavily
and understand how they work.

All method calls are automatically signed and include the authentication token.

Installation
------------

    gem install flickr_party
    
Usage
-----

    require 'rubygems'
    require 'flickr_party'
    
    API_KEY = '...'
    SECRET = '...'
    
    f = FlickrParty.new(API_KEY, SECRET)
    
    # The code supports real application authentication.
    url = f.auth_url # returns the url you should send the user to
    `open #{url}` # open in browser
    
    # This is just a way to pause until the user says go.
    # If you're building a gui app or web-based app, you will obviously do something different.
    print 'Press any key once you have authorized the app...'
    require "highline/system_extensions"
    HighLine::SystemExtensions.get_character
    
    token = f.complete_auth
    
    # The wrapper uses method_missing to accept any method supported by the API (now or in the future).
    # For instance, the method "flickr.activity.userPhotos" is called with the code below.
    
    data = f.flickr.activity.userPhotos('timeframe' => '10d', 'auth_token' => token)

    data['rsp'] # => data
