require File.join(File.dirname(__FILE__), 'helper')

class ScoreSourceYcombinatorTest < ScoreSourceTest
  context 'Oursignal::Score::Source::Ycombinator' do
    setup do
      @ycombinator = Oursignal::Score::Source::Ycombinator.new
    end

    context '.poll' do
      should 'run without errors' do
        assert_nothing_raised do
          Nokogiri::HTML.parse(@ycombinator.poll)
        end
      end
    end

    context '.work' do
      should 'run without errors' do
        assert_nothing_raised do
          @ycombinator.work(@ycombinator.poll)
        end
      end
    end
  end
end

