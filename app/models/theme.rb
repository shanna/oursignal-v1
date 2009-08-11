class Theme
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :unique_index => true
  # TODO: Paths to theme base?
  # property :path, Path

  has n, :users, User, :constraint => :protect
end
