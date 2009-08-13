xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title user.title
    xml.description user.description
    xml.link absolute_url(:users, user.username, :format => :rss)

    user.links.each do |i|
      xml.item do
        # TODO: score, velocity, sources etc. could all be here namespaced.
        xml.title i.title
        # xml.description i.description
        xml.pubDate i.created_at.to_s
        xml.link i.url
        xml.guid i.id
      end
    end
  end
end

