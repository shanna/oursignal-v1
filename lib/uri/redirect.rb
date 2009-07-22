require 'curb'

module URI
  module Redirect
    def follow!(*args, &block)
      final = follow(*args, &block)
      self.host = final.host
      self.path = final.path
      self
    end

    def follow(url = self, options = {})
      curl    = Curl::Easy.new(url.to_s)
      default = {:follow_location => true, :head => true}
      default.update(options)
      default.each{|k, v| curl.send("#{k}=", v)}

      curl.perform
      URI.parse(curl.last_effective_url)
    end
  end

  URI::Generic.send(:include, URI::Redirect)
  URI::HTTP.send(:include, URI::Redirect)
end
