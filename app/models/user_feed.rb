class UserFeed
  include DataMapper::Resource
  property :user_id, Integer, :key => true
  property :feed_id, Integer, :key => true
  property :score, Integer, :default => 50
  belongs_to :user
  belongs_to :feed

  def to_json(options = {})
    super options.update(:methods => [:feed])
  end
end
