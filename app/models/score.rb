require 'uri/redirect'

class Score
  include MongoMapper::Document
  key :source, String
  key :url,    String
  key :score,  Float, :default => 0

  # TODO: URL Type.
  def url=(url)
    uri = URI.parse(url)
    uri.extend(URI::Redirect)
    @url = uri.resolve!.to_s
  end
end
