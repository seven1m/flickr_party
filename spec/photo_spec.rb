require_relative 'spec_helper'
require_relative '../lib/flickr_party'

describe FlickrParty::Photo do

  let(:photo_hash) do
    {
      'id'       => '8545757071',
      'owner'    => '98624608@N00',
      'secret'   => '1dc18b8a5a',
      'server'   => '8516',
      'farm'     => '9',
      'title'    => '',
      'ispublic' => '1',
      'isfriend' => '0',
      'isfamily' => '0'
    }
  end

  subject do
    FlickrParty::Photo.new(photo_hash)
  end

  describe 'to_h' do
    it 'returns a hash' do
      expect(subject.to_h).to eq(photo_hash)
    end
  end

  it 'has a url' do
    expect(subject.url).to eq('https://farm9.static.flickr.com/8516/8545757071_1dc18b8a5a.jpg')
  end

end
