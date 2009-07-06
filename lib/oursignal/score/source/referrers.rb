require 'oursignal/score/source'

module Oursignal
  module Score
    class Source

      class Referrers < Source
        def score(links = [])
          # TODO: Cache this somewhere.
          Link.all(:'$where' => %q{
            
          })
        end
      end
    end # Source
  end # Score
end # Oursignal

__END__
http://www.thebroth.com/blog/118/bayesian-rating
br = ( (avg_num_votes * avg_rating) + (this_num_votes * this_rating) ) / (avg_num_votes + this_num_votes)
