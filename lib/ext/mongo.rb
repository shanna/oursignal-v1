require 'ext/string'

class BSON
  def self.to_utf8(str)
    str.to_utf8
  end
end

module MongoMapper
  class Key
    def get(value)
      # Allow block for default.
      if value.nil? && !default_value.nil?
        return default_value.respond_to?(:call) ? default_value.call : default_value
      end

      if type == Array
        value || []
      elsif type == Hash
        HashWithIndifferentAccess.new(value || {})
      else
        value
      end
    end
  end
end
