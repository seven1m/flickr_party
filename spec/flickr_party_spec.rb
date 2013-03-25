require_relative 'spec_helper'
require 'json'
require_relative '../lib/flickr_party'

auth_filename = File.expand_path('../auth.json', __FILE__)
if File.exist?(auth_filename)
  AUTH = JSON.parse(File.read(auth_filename))
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
      response['photos']['photo'].should be_an(Array)
    end

    it 'returns a user photo object' do
      response = subject.flickr.people.getPublicPhotos(user_id: '98624608@N00')
      photo = response['photos']['photo'].first
      expect(photo).to be_a(FlickrParty::Photo)
    end
  end

  describe '#arg_signature' do
    it 'returns a hash of arguments' do
      sig = subject.send(:arg_signature, 'foo' => 'bar')
      expect(sig).to eq('ae831c3856bbc8f1e54268e94e82be1f')
    end
  end

end
