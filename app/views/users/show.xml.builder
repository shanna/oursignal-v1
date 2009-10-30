xml.instruct! :xml, :version => "1.0"
xml.oursignal :version => "1.0", :username => user.username do
  (@links || user.links).each do |link|
    xml.link :id => link.id do
      xml.score link.score
      xml.velocity link.velocity
      xml.title link.title
      xml.url link.title, :href => link.url
      xml.referrers do
        link.referrers.each do |name, href|
         xml.url name, :href => href
        end
      end
      # TODO: timestamps?
    end
  end
end

