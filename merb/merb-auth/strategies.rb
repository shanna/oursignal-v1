Merb::Slices::config[:'merb-auth-slice-password'][:no_default_strategies] = true
Merb::Authentication.activate!(:default_openid)

class Merb::Authentication::Strategies::Basic::OpenID
  def find_user_by_identity_url(url)
    user_class.find_first('openid.identifier' => url)
  end
end # Merb::Authentication::Strategies::Basic::OpenID

