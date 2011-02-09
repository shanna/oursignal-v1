require 'oursignal/scheme'
require 'oursignal/scheme/entry'
require 'oursignal/scheme/link'

module Oursignal
  class Scheme
    class EntryLink < Scheme
      store :entry_links
      attribute :entry_id, Swift::Type::Integer, key: true
      attribute :link_id,  Swift::Type::Integer, key: true

      def entry; Oursignal::Scheme::Entry.get(entry_id) end
      def link;  Oursignal::Scheme::Link.get(link_id)   end
    end # EntryLink
  end # Scheme
end # Oursignal
