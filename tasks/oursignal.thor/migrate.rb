require File.join(File.dirname(__FILE__), 'common')

module Oursignal
  class Migrate < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'user', '(Re)create default oursignal user'
    def user
      User.first_or_create({:username => 'oursignal'},
        :username => 'oursignal',
        :fullname => 'OurSignal',
        :email    => 'enquiries@oursignal.com'
      )
    end
  end
end
