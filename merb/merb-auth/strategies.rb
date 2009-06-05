Merb::Slices::config[:'merb-auth-slice-password'][:no_default_strategies] = true
Merb::Authentication.activate!(:default_openid)
