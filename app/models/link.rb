require 'link/discover'
require 'link/update'
require 'link/meta'
require 'uri/domain'

class Link
  include Link::Discover
  include Link::Update

  include DataMapper::Resource
  property :id,               DataMapper::Types::Digest::SHA1.new(:url), :key => true, :nullable => false
  property :url,              URI, :length => 255, :nullable => false, :unique_index => true
  property :title,            String, :length => 255
  property :referrers,        Json
  property :score_average,    Float, :default => 0
  property :score_bonus,      Float, :default => 0
  property :score,            Float, :default => 0
  property :velocity_average, Float, :default => 0
  property :velocity,         Float, :default => 0, :index => true
  property :score_at,         DateTime, :index => true
  property :meta_at,          DateTime, :index => true
  property :referred_at,      DateTime
  property :created_at,       DateTime, :index => true
  property :updated_at,       DateTime

  has n, :feed_links, :constraint => :destroy!
  has n, :feeds, :through => :feed_links

  after :create, :selfupdate

  def to_json(options = {})
    {
      :url       => url,
      :title     => title,
      :score     => score,
      :velocity  => velocity,
      :referrers => referrers
    }.to_json
  end

  def title=(str = nil)
    words    = str.strip.split(/\s+/)
    sentence = ''
    sentence << "#{words.shift} " while !words.empty? && sentence.length < 120
    sentence.strip!
    sentence << '...' unless words.empty? || sentence =~ /[.!\?]$/
    attribute_set(:title, sentence)
  end

  %w{score_average score_bonus score velocity_average velocity}.each do |fl|
    define_method(:"#{fl}=") do |f|
      attribute_set(fl.to_sym, (f ? f.to_f.round(5) : 0))
    end
  end

  def domain
    url.domain
  end

  def copy(update = {})
    self.class.new(attributes(:name).except(:id).update(update))
  end
end # Link

