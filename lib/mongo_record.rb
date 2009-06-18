module Mongo
  class << self
    attr_reader :db
    def setup(db, *options)
      @db = XGen::Mongo::Driver::Mongo.new(*options).db(db, :pk => Key)
    end

    def collection(name)
      @db.collection(name.to_s.downcase)
    end
  end

  module Key
    def self.create_pk(row)
      return row if row[:_id].kind_of?(XGen::Mongo::Driver::ObjectID)
      row[:_id] ||= XGen::Mongo::Driver::ObjectID.new
      row
    end
  end # Key

  module Model
    def collection
      Mongo.collection(self)
    end

    def method_missing(m, *args, &block)
      begin
        target = collection
        unless target.respond_to?(m)
          super(m, *args, &block)
        else
          # TODO: LazyArray
          result = target.__send__(m, *args, &block)
          result = result.to_mongo if result.kind_of?(Hash)
          result = result.to_a.map{|m| m.to_mongo} if result.kind_of?(XGen::Mongo::Driver::Cursor)
          result
        end
      rescue Exception
        $@.delete_if{|s| %r"\A#{__FILE__}:\d+:in `method_missing'\z"o =~ s}
        ::Kernel::raise
      end
    end
  end # Model

  module Resource
    def self.included(model)
      model.extend Model
    end
    alias_method :model, :class
  end # Resource
end

class Object
  def to_mongo(collection = nil)
    self
  end
end

class Array
  def to_mongo(collection = nil)
    map{|v| v.to_mongo(collection)}
  end
end

class Hash
  def to_mongo(collection = nil)
    mash = map{|k, v| [k, v.to_mongo]}.to_mash
    if collection && mash[:_id]
      XGen::Mongo::Driver::DBRef.new(Mongo.collection(collection).name, mash[:_id])
    else
      mash
    end
  end
end

