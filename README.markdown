Flickr Party
============

Flickr Party is the simplest possible thing that might work for you. We build on HTTParty, and do a bit of `method_missing` magic to accept any method that the official Flickr API supports.

You can also (optionally) do authenticated API calls using the `auth_url` and `complete_auth` methods (see below).

Installation
------------

```sh
gem install flickr_party
```
    
Usage
-----

```ruby
require 'rubygems'
require 'flickr_party'

# get your key and secret from:
# http://www.flickr.com/services/apps/by/timothymorgan
API_KEY = '...'
SECRET = '...'

f = FlickrParty.new(API_KEY, SECRET)

# if you want to do authenticated calls, authenticate the user like so:
f.auth_url # open this in a browser for the user to confirm
# wait until confirmed, and then save the auth token...
token = f.complete_auth

# call any API method by calling it on the FlickrParty object directly
data = f.flickr.activity.userPhotos('timeframe' => '10d', 'auth_token' => token)

# data is presented vary raw, in the "rsp" key...
data['rsp'] # => data
```
