xml.instruct! :xml, :version => "1.0"
xml.oursignal :version => "1.0", :username => user.username do
  user.links.each do |i|
    xml.link :id => i.id, :score => i.score, :velocity => i.velocity do
      xml.url(i.title, :href => i.url)
      # TODO: sources, timestamps etc.
    end
  end
end

