require File.join(File.dirname(__FILE__), 'helper')

class ScoreSourceDeliciousTest < ScoreSourceTest
  context 'Oursignal::Score::Source::Delicious' do
    setup do
      @delicious = Oursignal::Score::Source::Delicious.new
    end

    context '.poll' do
      should 'run without errors' do
        assert_nothing_raised do
          Nokogiri::HTML.parse(@delicious.poll)
        end
      end
    end

    context '.work' do
      should 'run without errors' do
        assert_nothing_raised do
          @delicious.work(@delicious.poll)
        end
      end
    end
  end
end

