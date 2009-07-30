require 'digest/md5'
require 'digest/sha1'
require 'dm-core'
require 'zlib'

module DataMapper
  module Types
    class Digest < DataMapper::Type

      module InstanceMethods
        def self.included(model)
          model.class_eval <<-EOS, __FILE__, __LINE__
            before(:valid?, :digest) if method_defined?(:valid?)
            before(:save, :digest)
          EOS
        end

        def digest
          properties.each do |property|
            type = property.type
            type.respond_to?(:digest_map) || next
            type.digest_map.empty? and raise("Empty property list for digest #{property.name}")

            composite = type.digest_map.map do |p|
              cp = properties[p] || raise("Unknown property #{p} for digest #{property.name}")
              cp.value(attribute_get(p))
            end.compact.join
            attribute_set(property.name, type.digest(composite, property))
          end
          true
        end
      end

      def self.inherited(target)
        target.instance_variable_set("@primitive", self.primitive)
      end

      def self.digest_map
        @digest_map ||= []
      end

      def self.digest_map=(value)
        @digest_map = value
      end

      def self.new(*names)
        klass = Class.new(self)
        klass.digest_map = names
        klass
      end

      def self.digest(value, property)
        value
      end

      def self.bind(property)
        property.model.send(:include, InstanceMethods)
      end

      class CRC32 < Digest
        primitive Integer

        def self.digest(value, property)
          Zlib.crc32(value.to_s).to_i
        end
      end

      class SHA1 < Digest
        primitive String

        def self.digest(value, property)
          Digest::SHA1.hexdigest(value.to_s)
        end
      end

      class MD5 < Digest
        primitive String

        def self.digest(value, property)
          Digest::MD5.hexdigest(value.to_s)
        end
      end
    end # Digest
  end # Types
end # DataMapper

