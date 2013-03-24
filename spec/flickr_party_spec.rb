require_relative 'spec_helper'
require 'json'
require_relative '../lib/flickr_party'

if File.exist?('auth.json')
  AUTH = JSON.parse(File.read('auth.json'))
else
  puts 'You must create auth.json with your app id, secret, and token.'
  exit(1)
end

describe FlickrParty do

  subject do
    FlickrParty.new(AUTH['app_id'], AUTH['app_secret']).tap do |fp|
      fp.token = AUTH['token']
    end
  end

  it 'authenticates' do
    expect(subject.token).to be_a(String)
  end

  describe 'getPublicPhotos' do
    it 'returns user photos' do
      response = subject.flickr.people.getPublicPhotos(user_id: '98624608@N00')
      response['rsp']['photos']['photo'].should be_an(Array)
    end

    it 'returns a user photo object' do
      response = subject.flickr.people.getPublicPhotos(user_id: '98624608@N00')
      photo = response['rsp']['photos']['photo'].first
      expect(photo).to be_a(FlickrParty::Photo)
    end
  end

end
