require 'curb'
require 'uri/sanitize'

# Schema.
require 'oursignal/scheme/link'

module Oursignal
  class Link < Scheme::Link
    def match? match_url
      url == URI.sanitize(match_url).to_s
    end

    class << self
      def find id
        execute(%q{select * from links where id = ? or url = ?}, id.to_s.to_i, id).first
      end

      #--
      # TODO: Golf.
      # TODO: Dirty updating?
      def upsert attributes
        if link = find(attributes[:id] || attributes[:url])
          link.update({updated_at: Time.now, referred_at: Time.now}.merge(attributes))
        else
          link = create(attributes.merge(content_type: content_type(attributes[:url])))
        end
        link
      end

      private
        #--
        # TODO: Metauri is struggling under the load of TM lets not hit it just for a content_type.
        def content_type url
          begin
            curl = Curl::Easy.perform(url.to_s) do |e|
              e.follow_location       = true
              e.timeout               = 5
              e.headers['User-Agent'] = Oursignal::USER_AGENT
            end
            curl.content_type.to_s.match(%r{(?:application|audio|image|text|video)/[^;]+}) || 'text/html'
          rescue => error
            warn error
            'text/html'
          end
        end
    end
  end # Link
end # Oursignal

