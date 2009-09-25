require File.join(File.dirname(__FILE__), 'helper')
require 'math/uniform_distribution'

class MathUniformDistributionTest < MerbTest
  context 'Math::UniformDistribution' do
    setup do
      @it      = Math::UniformDistribution
      @buckets = lambda{ %w{.1 .2 .3 .4 .5 .6 .7 .8 .9 1}.map(&:to_f)}
    end

    should 'construct object' do
      assert_nothing_raised do
        @it.new(:test, nil, &@buckets)
      end
    end

    context 'instance' do
      setup do
        @ud = @it.new(:test, nil, &@buckets)
      end

      should 'find first bucket index in range' do
        assert_equal 0, @ud.at(0.1)
      end

      should 'find first bucket index out of range' do
        assert_equal 0, @ud.at(-0.5)
      end

      should 'find last bucket index in range' do
        assert_equal 9, @ud.at(1)
      end

      should 'find last bucket index out of range' do
        assert_equal 9, @ud.at(1.5)
      end

      should 'find bucket index' do
        assert_equal 4, @ud.at(0.5)
      end

      should 'have number of buckets' do
        assert_equal 10, @ud.buckets
      end
    end
  end
end
