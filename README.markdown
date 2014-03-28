# Flickr Party

Flickr Party is the simplest possible thing that might work for you. We build on HTTParty, and do a bit of `method_missing` magic to accept any method that the official Flickr API supports.

You can also (optionally) do authenticated API calls using the `auth_url` and `complete_auth` methods (see below).

## Installation

```sh
gem install flickr_party
```

## Usage

```ruby
require 'rubygems'
require 'flickr_party'

# get your key and secret from:
# http://www.flickr.com/services/apps
API_KEY = '...'
SECRET = '...'

f = FlickrParty.new(API_KEY, SECRET)

# if you want to do authenticated calls, authenticate the user like so:
f.auth_url # open this in a browser for the user to confirm
# wait until confirmed, and then save the auth token...
token = f.complete_auth

# call any API method by calling it on the FlickrParty object directly
# pass in any needed parameters as a hash
data = f.flickr.activity.userPhotos('timeframe' => '10d')

puts data['photos'].first.url
```

## Copyright

Copyright (c) 2014, Tim Morgan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
