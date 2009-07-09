require 'oursignal/score/source'

module Oursignal
  module Score
    class Source

      class Referrers < Source
        def score(links = [])
          # TODO: Caching.
          average = MongoMapper.database.eval(%q{
            return db.group({
              cond:    {},
              initial: {max: 0, total: 0},
              key:     {},
              ns:      'links',
              reduce:  function (obj, prev) {
                prev.total += obj.referrers.length;
                if (obj.referrers.length > prev.max) prev.max = obj.referrers.length;
              }
            });
          })

          total, max = average['0'].values_at('total', 'max')
          # TODO: Do something with these number :P
        end
      end
    end # Source
  end # Score
end # Oursignal

__END__
http://www.thebroth.com/blog/118/bayesian-rating
br = ( (avg_num_votes * avg_rating) + (this_num_votes * this_rating) ) / (avg_num_votes + this_num_votes)

