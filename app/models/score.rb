class Score
  include MongoMapper::Document
  key :source, String
  key :url,    String
  key :score,  Float, :default => 0

  def self.first_or_new_by_url(url, source = nil)
    options = {:url => URI.sanatize(url, false)}
    options[:source] = source if source

    score = first(:conditions => options)
    return score if score

    options[:url] = URI.sanatize(url)
    first(:conditions => options) || new(options)
  end
end
