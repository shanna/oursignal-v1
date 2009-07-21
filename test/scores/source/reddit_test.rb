require File.join(File.dirname(__FILE__), 'helper')

class ScoreSourceRedditTest < ScoreSourceTest
  context 'Oursignal::Score::Source::Reddit' do
    setup do
      @reddit = Oursignal::Score::Source::Reddit.new
    end

    context '.poll' do
      should 'run without errors' do
        assert_nothing_raised do
          JSON.parse(@reddit.poll)
        end
      end
    end

    context '.work' do
      should 'run without errors' do
        assert_nothing_raised do
          @reddit.work(@reddit.poll)
        end
      end
    end
  end
end

