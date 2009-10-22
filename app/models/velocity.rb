require 'velocity/normalize'

class Velocity
  include DataMapper::Resource
  extend Velocity::Normalize

  property :link_id,    String, :length => 40, :key => true
  property :created_at, DateTime, :key => true
  property :velocity,   Float
end
