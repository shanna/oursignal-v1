module Oursignal
  class User < Swift::Scheme
    store :users
    attribute :id,              Swift::Type::Integer, serial: true, key: true
    attribute :theme_id,        Swift::Type::Integer, default: proc{ Oursignal::Theme.first('name = ?', 'treemap') }
    attribute :email,           Swift::Type::String
    attribute :username,        Swift::Type::String
    attribute :password,        Swift::Type::String
    attribute :password_reset,  Swift::Type::String
    attribute :gravatar,        Swift::Type::String
    attribute :show_new_window, Swift::Type::Boolean, default: false
    attribute :updated_at,      Swift::Type::Time,    default: proc{ Time.now }
    attribute :created_at,      Swift::Type::Time,    default: proc{ Time.now }

    def theme;      Oursignal::Theme.get(theme_id) end
    def user_feeds; Oursignal::UserFeed.all('user_id = ?', user_id) end
  end # User
end # Oursignal

