module Oursignal
  class Feeds < Thor
    def self.new(*args)
      Oursignal.merb_env
      super
    end

    desc 'update', 'Update links from RSS feeds.'
    def update
      Link.all(
        :updated_at => {:'$lt' => Time.now - 60 * 30},
        :feed       => {:'$ne' => nil}
      ).each(&:selfupdate)
    end
  end # Feeds
end # Oursignal
