class Link
  module Meta

    #--
    # TODO: Golf all those link meta_at updates.
    def self.update
      adapter = Link.repository.adapter
      urls    = adapter.query('select url from links where meta_at is null')
      while !urls.empty?
        chunk = urls.slice!(0..10).compact
        URI::Meta.multi(chunk) do |meta|
          link = Link.first(:url => URI.sanatize(meta.uri)) rescue next
          next unless link

          begin
            if !meta.errors?
              title = meta.title.to_utf8
              title = link.title if title.blank?
              if meta.redirect?
                if last_effective_link = Link.first(:url => URI.sanatize(meta.last_effective_uri))
                  last_effective_link.update(:meta_at => DateTime.now, :title => title)
                else
                  last_effective_link = link.copy(
                    :url     => URI.sanatize(meta.last_effective_uri),
                    :title   => title,
                    :meta_at => DateTime.now
                  )
                  last_effective_link.save || next
                end
                adapter.execute('update feed_links set link_id = ? where link_id = ?', elink.id, link.id) rescue nil
                link.destroy
              else
                link.update(:meta_at => DateTime.now, :title => title) unless link.meta_at
              end
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
end # Link
