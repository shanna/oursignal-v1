class Struct
  def to_json(*args)
    attributes.to_json(*args)
  end
end
