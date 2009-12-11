class Link
  module Meta
    def self.update
      urls = Link.repository.adapter.query('select url from links where meta_at is null')
      while !urls.empty?
        chunk = urls.slice!(0..10).compact
        URI::Meta.multi(chunk) do |meta|
          link = Link.first(:url => URI.sanatize(meta.uri)) || Link.first(:url => meta.uri) || next
          link.update(:meta_at => DateTime.now)
          begin
            update_link(link, meta)
          rescue => error
            DataMapper.logger.error(%Q{#{error.message}:\n#{error.backtrace.join("\n")}})
          end
        end
      end
    end

    protected
      def self.update_link(link, meta)
        return unless !meta.errors? && [200, 302].include?(meta.status)
        title = (meta.title || '').to_utf8
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
            return unless last_effective_link.save
          end
          Link.repository.adapter.execute(
            'update feed_links set link_id = ? where link_id = ? on duplicate key ignore',
            last_effective_link.id,
            link.id
          )
          link.destroy
        else
          link.update(:title => title)
        end
      end
  end # Meta
end # Link
