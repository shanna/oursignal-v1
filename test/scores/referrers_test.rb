require File.join(File.dirname(__FILE__), 'helper')

class ReferrersTest < ScoreTest
  context Oursignal::Score::Source::Referrers do
    setup do
      Link.destroy_all
      @score = Oursignal::Score::Source::Referrers.new
    end

    context '.pending' do
      setup do
        @links = [] << Link.create(:url => 'http://oursignal.com/foo.rss')
        @links << Link.create(:url => 'http://oursignal.com/bar.rss')
        @links.first.scores << ::Score.new(:source => @score.name, :score => 0.5, :updated_at => Time.now)
        @links.first.save
      end
=begin
      should 'return an array' do
        assert_kind_of Array, @score.pending
      end

      should 'return unscored referrer' do
        pending = @score.pending
        assert pending.include?(@links.last)
        assert !pending.include?(@links.first)
      end
=end
      should 'do stuff' do
        pending = @score.pending
        @score.score(pending)
      end
    end

  end
end # ReferrersTest

