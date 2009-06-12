class Entry < MongoRecord::Base
  collection_name :entries
  fields :feeds, :link, :title, :description, :published
end # Entry

