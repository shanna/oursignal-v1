require 'curb'
require 'moneta'
require 'moneta/memory'

module URI
  module Redirect
    class RedirectError < RuntimeError; end

    def follow!(*args, &block)
      final = follow(*args, &block)
      self.host = final.host
      self.path = final.path
      self
    end

    def follow(url = nil, options = {})
      url = to_s if url.respond_to?(:to_s)
      unless effective_url = Cache.get(url)
        curl    = Curl::Easy.new(url)
        default = {
          # Fake a real browser!
          :headers           => {
            'User-Agent'      => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-GB; rv:1.9.0.11) Gecko/2009060214 Firefox/3.0.11',
            'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          },
          :follow_location   => true,
          :head              => true,
          :max_redirects     => 10,
          :timeout           => 10
        }.update(options)
        default.each{|k, v| curl.send("#{k}=", v)}

        begin
          curl.perform
          effective_url = curl.last_effective_url
        rescue => error
          raise RedirectError, "#{url}, #{error.message}"
        end
      end

      Cache.store(url, effective_url)
      URI.parse(effective_url)
    end

    class Cache
      cattr_accessor :moneta, :expires_in
      self.moneta     = Moneta::Memory.new
      self.expires_in = 86_400 # 24 hours

      class << self
        def store(key, url)
          moneta.store(key, url, :expires_in => expires_in)
        end

        def get(key)
          moneta[key]
        end
      end
    end
  end

  URI::Generic.send(:include, URI::Redirect)
  URI::HTTP.send(:include, URI::Redirect)
end
