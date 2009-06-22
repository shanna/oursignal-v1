module Oursignal
  class Feeds < Thor
    def self.new(*args)
      Oursignal.merb_env
      super
    end

    desc 'update', 'Update feeds/items'
    def update
      Feed.find('updated_at' => {'$lte' => Time.now - 60 * 30}).each(&:selfupdate)
    end
  end # Feeds
end # Oursignal
