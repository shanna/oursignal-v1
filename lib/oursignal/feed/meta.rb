require 'oursignal/job'

module Oursignal
  module Feed

    # Update link meta info.
    class Meta < Job

      #--
      # TODO: Golf all those link meta updates.
      def call
        adapter = Link.repository.adapter
        urls    = adapter.query('select url from links where meta_at is null')
        while !urls.empty?
          chunk = urls.slice!(0..10).compact
          URI::Meta.multi(chunk) do |meta|
            link = Link.first(:url => URI.sanatize(meta.uri)) rescue next
            next unless link

            begin
              if meta.redirect? && !meta.errors?
                unless elink = Link.first(:url => URI.sanatize(meta.last_effective_uri))
                  # TODO: This eats dick and may break when you add new properties to Link.
                  # The intention here is to clone everything in the old link and set url (thus id) and meta_at.
                  elink = Link.create(
                    :url         => URI.sanatize(meta.last_effective_uri),
                    :domains     => link.domains,
                    :title       => meta.title.to_utf8,
                    :meta_at     => DateTime.now,
                    :referred_at => link.referred_at,
                    :created_at  => link.created_at,
                    :updated_at  => link.updated_at
                  ) || next
                end
                elink.update(:meta_at => DateTime.now) unless elink.meta_at
                adapter.execute('update feed_links set link_id = ? where link_id = ?', elink.id, link.id) rescue nil
                link.destroy
              else
                link.update(:meta_at => DateTime.now) unless link.meta_at
              end
            rescue => error
              Merb.logger.error(error.message)
              link.update(:meta_at => DateTime.now) unless link.meta_at
            end
          end
        end
      end

    end # Meta
  end # Feed
end # Oursignal

