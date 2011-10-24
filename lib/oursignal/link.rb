require 'uri/meta'
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
          content_type = URI.parse(attributes.fetch(:url)).meta.content_type rescue 'text/html'
          link         = create(attributes.update(content_type: content_type))
        end
        link
      end
    end
  end # Link
end # Oursignal
