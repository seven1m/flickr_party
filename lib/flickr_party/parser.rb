class FlickrParty
  class FlickrParser < HTTParty::Parser
    def xml
      super['rsp'].tap do |result|
        if result['photos']
          # eliminate the redundant key names
          result['photos'] = result['photos'].delete('photo')
        end
      end
    end
  end
end
