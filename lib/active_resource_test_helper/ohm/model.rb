require 'ohm'

module Ohm # :nodoc:
  # Adds some convenience methods to Ohm::Model[http://github.com/soveran/ohm].
  class Model
    # Convert the model to hash.
    def to_hash
      hash = {:id => self.id.to_i}
      self.attributes.each do |attr|
        hash[attr] = self.send attr
      end
      hash
    end

    # Destroy all instances of this model
    def self.destroy_all
      self.all.each do |i|
        i.delete
      end
    end

    # Return the number of instances of this model saved into redis
    def self.count
      self.all.size
    end
  end
end