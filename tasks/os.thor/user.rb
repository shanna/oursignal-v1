require File.join(File.dirname(__FILE__), 'common')

module Os
  class User < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'links(username)', %q{Links for a username.}
    def links(username)
      DataMapper.logger.level = :error
      user  = ::User.first(:username => username)

      puts 'link_id  | score_avg(sa) | score_bonus(sb) | (sa * sb) | age(a)    | (sa * sb * a) | score    | velocity_avg | velocity'
      puts '---------+---------------+-----------------+-----------+-----------+---------------+----------+--------------+---------'
      user.links.each do |l|
        puts(
          '%.8s | %+.5f      | %+.5f        | %+.5f  | %+.5f  | %+.5f      | %+.5f | %+.5f     | %+.5f' %
          [
            l.id,
            l.score_average,
            l.score_bonus,
            (l.score_average * l.score_bonus),
            l.age,
            (l.score_average * l.score_bonus * l.age),
            l.score,
            l.velocity_average,
            l.velocity
          ]
        )
      end
    end

    desc 'feeds(username)', %q{Feeds for username.}
    def feeds(username)
      DataMapper.logger.level = :error
      user  = ::User.first(:username => username)
      links = user.links.to_a

      puts 'feed_id  | links | user_score | user_links | domain'
      puts '---------+-------+------------+------------+-------'
      user.user_feeds.each do |uf|
        count = links.find_all{|l| l.domains.include?(uf.feed.domain)}.size
        puts('%.8s | %5d |    %.5f |   %2d (%2d%%) | %s' %
          [
            uf.feed_id,
            uf.feed.links.count,
            uf.score,
            count,
            (count.to_f / links.size) * 100,
            uf.feed.domain
          ]
        )
      end
    end
  end
end
