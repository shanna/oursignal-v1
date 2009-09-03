xml.instruct! :xml, :version => "1.0"
xml.oursignal :version => "1.0", :username => user.username do
  user.links.each do |link|
    xml.link :id => link.id do
      xml.score link.score
      xml.velocity link.velocity
      xml.title link.title
      xml.url link.url
      xml.domains do
        link.domains.each do |domain|
         xml.domain domain
        end
      end
      # TODO: timestamps?
    end
  end
end

