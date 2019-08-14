struct NamedTuple
  def overwrite(other : NamedTuple, target : Array(Object) = [] of Object)
    hash = self.to_h
    self.each do |k, v|
      hash[k] = other[k] if target.includes?(v)
    end
    self.class.types.from(hash)
  end
end
