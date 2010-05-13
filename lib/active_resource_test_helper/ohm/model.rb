require 'ohm'

module Ohm
  class Model
    def to_hash
      hash = {:id => self.id.to_i}
      self.attributes.each do |attr|
        hash[attr] = self.send attr
      end
      hash
    end

    def self.destroy_all
      self.all.each do |i|
        i.delete
      end
    end

    def self.count
      self.all.size
    end
  end
end