require 'oursignal/job'

module Oursignal
  module Feed

    # Update link meta info.
    class Meta < Job

      def call
        adapter = Link.repository.adapter
        urls    = adapter.query('select url from links where meta_at is null')

        while !urls.empty?
          chunk = urls.slice!(0..10).compact
          # URI::Meta.multi(chunk, :connection_timeout => 2, :timeout => 10) do |meta|
          URI::Meta.multi(chunk) do |meta|
            next if meta.errors?
            link  = Link.first(:url => URI.sanatize(meta.uri)) || next
            elink = Link.first_or_create({:url => URI.sanatize(meta.last_effective_uri)}, :title => meta.title.to_s) || next

            if elink != link
              adapter.execute('update feed_links set link_id = ? where link_id = ?', elink.id, link.id)
              link.destroy
            end

            elink.meta_at = DateTime.now
            elink.save
          end
        end
      end

    end # Meta
  end # Feed
end # Oursignal

