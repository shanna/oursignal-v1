class Application < Merb::Controller
  before do
    unless params[:openid_url].blank?
      uri = Addressable::URI.heuristic_parse(params[:openid_url])
      params[:openid_url] = OpenID.normalize_url(uri.normalize)
    end
  end

  #--
  # TODO: Move.
  module HttpCache
    def http_cacheable?
      true
    end

    def http_no_cache(field = 'Set-cookie')
      nc = ["no-cache", [field].flatten.compact.join(',')].compact.join('=')
      headers['Cache-Control'] = nc
      true
    end

    def http_max_age(t)
      return false unless http_cacheable?
      headers['Cache-Control'] = "max-age=#{t}"
      true
    end

    def http_purge(*opts)
      # TODO: Use current path by :url if opts.empty?
      begin
        http_cache.purge(*opts)
      rescue Errno::ECONNREFUSED
        Merb.logger.error(%q{Connection to Varnish admin port refused.})
        false
      end
    end

    private
      def http_cache
        Varnish::Client.new # 127.0.0.1:6082 (admin)
      end
  end
  include HttpCache

  protected
    def purge_user_feed
      if session.user
        http_purge(:url, url(:links, session.user.username).sub(%r{/$}, ''))
        http_purge(:url, url(:links, session.user.username))
      end
    end

    def ensure_authorized
      raise Forbidden unless session.user.username == params[:username]
    end
end
