require File.join(File.dirname(__FILE__), 'common')

module Os
  class User < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'links', %q{Links for a username.}
    def links(username)
      user  = ::User.first(:username => username)
      links = user.links.to_a

      puts 'id       | score_avg(sa) | score_bonus(sb) | (sa * sb) | age(a)    | (sa * sb * a) | score    | velocity_avg | velocity'
      puts '---------+---------------+-----------------+-----------+-----------+---------------+----------+--------------+---------'
      links.each do |l|
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
  end
end
