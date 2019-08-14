struct NamedTuple
  def overwrite(other : NamedTuple, target : Array(Object) = [] of Object)
    self_hash = self.to_h
    other_hash = other.to_h
    self.each do |k, v|
      self_hash[k] = other_hash[k] if target.includes?(v)
    end
    self.class.types.from(self_hash)
  end
end
