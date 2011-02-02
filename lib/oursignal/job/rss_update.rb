require 'xml-sax-machines'

# Business.
require 'oursignal/feed'

module Oursignal
  module Job
    class RssUpdate
      extend Resque::Plugins::Lock
      @queue = :rss_update

      class << self
        def perform url, path
          builder = XML::SAX::FragmentBuilder.new(nil, 
            '//channel/entry' => lambda{|el| puts 'atom item' },
            '//feed/item'     => lambda{|el| puts 'rss entry' }
          )
          parser = Nokogiri::XML::SAX::Parser.new(builder)
          parser.parse(File.open(path))
        end
      end
    end # RssUpdate
  end # Job
end # Oursignal
