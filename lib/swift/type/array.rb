require 'swift/type'

#--
# TODO: More types.
module Swift
  module Type
    class FloatArray < Attribute
      ARRAY_RE = %r/
        (?<=[\{,]) # Leading { or ,
        [^\},]+    # Float
        | NULL     # or nil
      /x

      def self.load string
        return unless string
        string.scan(ARRAY_RE).map{|s| s == 'NULL' ? nil : Float(s)}
      end

      def self.dump array = []
        '{' + array.map{|v| v.nil? ? 'NULL' : v}.join(',') + '}'
      end

      def define_scheme_methods scheme
        scheme.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name};        #{self.class}.load(tuple.fetch(:#{field}, nil))   end
          def #{name}= value; tuple.store(:#{field}, #{self.class}.dump(value)) end
        RUBY
      end
    end
  end # Type
end # Swift
