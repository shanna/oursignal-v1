# encoding: utf-8

module Oursignal
  module Cli
    module Devel
      module Data
        def self.create
          warn 'creating users...'
          Profile.create(email: 'test@oursignal.local', username: 'test', password: 'test')
          Profile.create(email: 'shane@oursignal.local', username: 'shane', password: 'test')
        end
      end # Data
    end # Devel
  end # Cli
end # Oursignal
