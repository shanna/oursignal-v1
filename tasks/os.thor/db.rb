require File.join(File.dirname(__FILE__), 'common')

module Os
  class Db < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'migrate', '(Re)create default oursignal defaults'
    def migrate
      # TODO: Move to an actual migration.
      %w{treemap list}.each{|theme| Theme.first_or_create(:name => theme)}
      User.first_or_create({:username => 'oursignal'},
        :username => 'oursignal',
        :email    => 'enquiries@oursignal.com'
      )
    end
  end
end
