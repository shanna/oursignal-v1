require 'digest/sha1'

class User
  include DataMapper::Resource
  property :id,             Serial
  property :theme_id,       Integer, :nullable => false, :default => proc {Theme.first(:name => 'treemap').id rescue nil}
  property :username,       String, :nullable => false, :length => (2..20), :format => /^[a-z0-9][a-z0-9\-]+$/i
  property :password,       String, :length => 40
  property :password_reset, String, :length => 40
  property :email,          String, :nullable => false, :length => 255, :format => :email_address
  property :openid,         String, :length => 255
  property :description,    String, :length => 255
  property :tags,           String, :length => 255
  property :created_at,     DateTime
  property :updated_at,     DateTime

  belongs_to :theme
  has n, :user_feeds, :constraint => :destroy!
  has n, :feeds, :through => :user_feeds

  validates_is_unique   :username
  validates_with_method :username, :method => :validate_username_reserved
  validates_present     :password

  FEEDS = {
    # TODO: It sucks hard coding local feeds like this but I'm pressed for time.
    'http://staging.oursignal.com/rss/digg.rss' => 0.2,
    'http://www.reddit.com/.rss'                => 0.7,
    'http://feeds.delicious.com/v2/rss/popular' => 0.6,
    'http://news.ycombinator.com/rss'           => 0.3,
  }.freeze

  before :save do
    self.password = digest_password(password) if attribute_dirty?(:password)
  end

  after :create do
    FEEDS.map do |url, score|
      feed = Feed.discover(url) || next
      user_feeds.first_or_create({:feed => feed}, :score => score)
    end
  end

  def title
    "#{username}'s feed"
  end

  def description
    description = attribute_get(:description)
    description = %Q{#{username}'s custom oursignal.com feed.} if description.blank?
    description
  end

  def self.authenticate(username, password)
    new(:username => username, :password => password).authenticate
  end

  def authenticate
    self.class.first(:conditions => {:username => username, :password => digest_password(password)})
  end

  def links(limit = 50)
    results = user_links(limit)
    return results if results.empty?

    domains  = feeds.map(&:domain)
    max, min = results.first.final_score, results.last.final_score
    results.map do |row|
      link          = Link.new(row.attributes.except(:final_score))
      link.domains  &= domains
      link.score    = (row.final_score - min) / (max - min)
      link.score    = 1.to_f if link.score.nan? || link.score.infinite? || max <= min
      link.score    = 0.01 if link.score < 0.01
      link.score    = link.score.round(2)
      link
    end
  end

  private
    def user_links(limit)
      Link.repository.adapter.query(%q{
        select
          l.*,
          (l.score * ((
            select MAX(uf2.score)
            from user_feeds uf2
            join feed_links fl2 on fl2.feed_id = uf2.feed_id
            where
              fl2.link_id     = l.id
              and uf2.user_id = uf.user_id
          ) * 0.5 + 0.5)) as final_score
          from links l
          inner join feed_links fl on l.id = fl.link_id
          inner join user_feeds uf on fl.feed_id = uf.feed_id
          where
            uf.user_id = ?
            and l.domains is not null
          group by l.id
          order by final_score desc
          limit ?
        },
        id, limit
      )
    end

    def digest_password(password)
      Digest::SHA1.hexdigest('some salt' + password.to_s)
    end

    RESERVED_USERNAMES = %w{
      rss static user admin monit
      login signup openid recover password
      image stylesheet javascript theme
      favicon robot
      default index main root owner webmaster stateless
    }.freeze
    def validate_username_reserved
      if username =~ /^(?:#{RESERVED_USERNAMES.join('|')})/i
        return [false, 'Username %s is already taken' % username]
      end
      true
    end
end

