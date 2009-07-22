require 'curb'
require 'moneta'
require 'moneta/memory'

module URI
  module Redirect
    def follow!(*args, &block)
      final = follow(*args, &block)
      self.host = final.host
      self.path = final.path
      self
    end

    def follow(url = self, options = {})
      unless effective_url = Cache.get(url.to_s)
        curl    = Curl::Easy.new(url.to_s)
        default = {:follow_location => true, :head => true}
        default.update(options)
        default.each{|k, v| curl.send("#{k}=", v)}

        curl.perform
        effective_url = curl.last_effective_url
      end

      Cache.store(url.to_s, effective_url)
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
