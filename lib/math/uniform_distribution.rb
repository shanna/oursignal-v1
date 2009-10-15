require 'moneta'
require 'moneta/memory'

module Math

  #==== Notes
  # I don't know the real name. We call it 'the bucket thing' most of the time.
  #--
  # TODO: Real name.
  class UniformDistribution
    attr_reader :buckets

    def initialize(name, expires_in = nil, &reload)
      @name, @expires_in, @reload = name.to_s, expires_in, reload
      cache = Cache.get(@name) || self.reload
      @buckets ||= cache.size
    end

    def reload
      cache   = @reload.call
      options = {}
      options.update(:expires_in => @expires_in) if @expires_in
      raise "Expected block to return Array but got '#{cache.class}'" unless cache.is_a?(Array)
      @buckets ||= cache.size
      Cache.store(@name, cache, options)
      cache
    end

    def at(bucket = nil)
      find  = cache.find{|r| bucket <= r} || cache.last
      cache.index(find)
    end

    def cache
      Cache.get(@name) || reload
    end

    class Cache
      @@cache = Moneta::Memory.new

      class << self
        def store(key, buckets, options = {})
          @@cache.store(key, buckets, options) unless @@cache.nil?
        end

        def get(key)
          @@cache[key] unless @@cache.nil?
        end

        def cache=(cache)
          warn 'Turning off caching is poor form, for longer processes consider using moneta/memcached' if cache.nil?
          @@cache = cache
        end
      end
    end # Cache
  end # UniformDistribution
end # Math
