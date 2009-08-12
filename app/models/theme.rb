class Theme
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :unique_index => true
  # TODO: Paths to theme base?
  # property :path, Path

  has n, :users, User, :constraint => :protect

  def css
    "/themes/#{name.downcase}/theme.css"
  end

  def js
    "/themes/#{name.downcase}/theme.js"
  end
end
