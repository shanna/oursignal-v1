require 'moneta'
require 'moneta/memory'

module Math

  #==== Notes
  # I don't know the real name. We call it 'the bucket thing' most of the time.
  #--
  # TODO: Real name.
  class UniformDistribution
    attr_reader :buckets

    @@cache = Moneta::Memory.new
    def self.cache=(moneta)
      @@cache = moneta
    end

    def initialize(name, expires_in = nil, &reload)
      @name, @expires_in, @reload = name.to_s, expires_in, reload
      create_buckets
    end

    def at(bucket = nil)
      cache = create_buckets
      find  = cache.find{|r| bucket <= r} || cache.last
      cache.index(find)
    end

    protected
      def create_buckets
        unless cache = @@cache[@name] and @expires_in
          cache = @reload.call
          raise "Expected block to return Array but got '#{cache.class}'" unless cache.is_a?(Array)
          @@cache.store(@name, cache, :expires_in => @expires_in) if @expires_in
        end
        @buckets ||= cache.size
        cache
      end
  end # UniformDistribution
end # Math
