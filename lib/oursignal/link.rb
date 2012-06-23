require 'curb'
require 'uri/sanitize'

# Schema.
require 'oursignal/scheme/link'

module Oursignal
  class Link < Scheme::Link
    def match? match_url
      URI.sanitize(url).to_s == URI.sanitize(match_url).to_s
    end

    class << self
      def find id
        execute(%q{select * from links where id = ? or url = ?}, id.to_s.to_i, id).first
      end

      def create attributes
        unless attributes[:url].nil?
          attributes.merge!(content_type: content_type(attributes[:url])) if attributes[:content_type].nil?
          attributes.merge!(meta(attributes[:url])) if attributes[:content_type].to_s.match(/text\/html/)
        end
        super attributes
      end

      #--
      # TODO: Golf.
      # TODO: Dirty updating?
      def upsert attributes
        if link = find(attributes[:id] || attributes[:url])
          link.update({updated_at: Time.now, referred_at: Time.now}.merge(attributes))
        else
          link = create(attributes)
        end
        link
      end

      private
        #--
        # TODO: Having this query not async is poor.
        # Thanks for the API though Barney.
        def meta url
          begin
            curl = Curl::Easy.perform('http://dingus.in/condense.js?uri=' + CGI.escape(url.to_s)) do |e|
              e.timeout               = 30
              e.headers['User-Agent'] = Oursignal::USER_AGENT
            end
            doc = Yajl.load(curl.body_str, symbolize_keys: true)
            return {summary: doc[:summary].first, tags: Yajl.dump(doc[:tags])}
          rescue => error
            warn 'ERROR: Dingus (%s): %s' % [url, error.inspect]
          end
          {summary: '', tags: '[]'}
        end

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
            warn 'ERROR: Content Type (%s): %s' % [url, error.inspect]
            'text/html'
          end
        end
    end
  end # Link
end # Oursignal

