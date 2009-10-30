migration 6, :remove_links_domains do
  up do
    execute %q{alter table links drop column domains}
    Link.all.each do |link|
      link.update(:referrers => link.feed_links.map{|fl| [fl.feed.domain, fl.url]}.to_mash)
    end
  end

  down do
    execute %q{alter table links add column domains text default null}
    Link.all.each do |link|
      link.update(:domains => link.feeds.map(&:domain))
    end
  end
end
