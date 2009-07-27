Merb::Slices::config[:'merb-auth-slice-password'][:no_default_strategies] = true
Merb::Authentication.activate!(:default_password_form)
Merb::Authentication.activate!(:default_openid)
# Merb::Authentication.activate!(:facebook)

class Merb::Authentication::Strategies::Basic::OpenID
  def required_reg_fields
    %w{fullname nickname email}
  end

  def on_success!(response, sreg_response)
    if user = find_user_by_identity_url(response.identity_url)
      return user
    end

    sreg = sreg_response ? sreg_response.data : {}
    user = Merb::Authentication.user_class.new(
      :username => sreg['nickname'],
      :fullname => sreg['fullname'],
      :email    => sreg['email'],
      :openid   => response.identity_url
    )
    return user if user.save

    request.session.authentication.errors.clear!
    request.session.authentication.errors.add(:openid, 'There was an error while creating your user account')
    nil
  end

  def find_user_by_identity_url(url)
    user_class.first(:conditions => {:openid => url})
  end
end # Merb::Authentication::Strategies::Basic::OpenID

