Flickr API Wrapper
==================

Wrapper for the Flickr API, with real application authentication.

About
-----

This piece of code uses HTTParty for its magic. All Flickr methods should
be supported, but you'll still need to reference the Flickr API docs heavily
and understand how they work.

All method calls are automatically signed and include the authentication token.

Installation
------------

    sudo gem install seven1m-flickr -s http://gems.github.com
    
Usage
-----

    require 'rubygems'
    require 'flickr'
    
    API_KEY = '...'
    SECRETE = '...'
    
    f = Flickr.new(API_KEY, SECRET)
    
    # The code supports real application authentication.
    f.auth_url # returns the url you should send the user to
    f.complete_auth # once the user has authorized the app thru flickr
    
    # The wrapper uses method_missing to accept any method supported by the API (now or in the future).
    # For instance, the method "flickr.activity.userPhotos" is called with the code below.
    
    f.flickr.activity.userPhotos('timeframe' => '10d')