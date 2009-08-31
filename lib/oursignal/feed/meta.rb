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

            if meta.redirect?
              unless elink = Link.first(:url => URI.sanatize(meta.last_effective_uri))
                # TODO: This eats dick and may break when you add new properties to Link.
                # The intention here is to clone everything in the old link and set url (thus id) and meta_at.
                elink = Link.create(
                  :url         => URI.sanatize(meta.last_effective_uri),
                  :domains     => link.domains,
                  :title       => meta.title.to_s,
                  :meta_at     => DateTime.now,
                  :referred_at => link.referred_at,
                  :created_at  => link.created_at,
                  :updated_at  => link.updated_at
                ) || next
              end
              elink.update(:meta_at => DateTime.now) unless elink.meta_at
              adapter.execute('update feed_links set link_id = ? where link_id = ?', elink.id, link.id)
              link.destroy
            else
              link.update(:meta_at => DateTime.now) unless link.meta_at
            end
          end
        end
      end

    end # Meta
  end # Feed
end # Oursignal

