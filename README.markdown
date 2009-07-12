Campaign Monitor API Wrapper
============================

Lightweight wrapper for Campaign Monitor API over HTTP

About
-----

It's possibly exaggeration to call this a "library" since it's really
only a class that utilizes HTTParty -- a wonderful gem for consuming REST
APIs. The code here is only about 20 lines or so; HTTParty does all the
hard work. Just thought I'd mention that.

Installation
------------

    sudo gem install seven1m-campaign_monitor -s http://gems.github.com
    
Usage
-----

First, familiarize yourself with the API documentation here: http://www.campaignmonitor.com/api/

    require 'rubygems'
    require 'campaign_monitor'
    
    API_KEY = '...'
    
    cm = CampaignMonitor.new(API_KEY)
    
    # The wrapper uses method_missing to accept any method supported by the API (now or in the future).
    # For instance, the method "Subscriber.Add" is called with the code below.
    
    cm.Subscriber.Add(
      'ListID' => '...',
      'Email'  => 'tim@timmorgan.org',
      'Name'   => 'Tim Morgan'
    )
    
    # 'ApiKey' is passed in automatically for each method call.
    # Other arguments should be passed as a hash to the method.
    
    