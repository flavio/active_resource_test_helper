require 'ohm'

# Adds a new type of factory to factory_girl[http://github.com/thoughtbot/factory_girl].
class Factory
  # Define a new factory to use inside of ActiveRecord tests.
  # Uses the same syntax of factory_girl[http://github.com/thoughtbot/factory_girl].
  def self.define_active_resource_factory name, options = {}, &definition
    raise "no block given" unless block_given?

    Factory.define name, options.dup, &definition

    return if options.include? :parent
    return if options.include?(:class) and const_defined?(options[:class].to_s.camelcase)

    if options.include?(:class) and !const_defined?(options[:class].to_s.camelcase)
      model_class_name = options[:class].to_s
    else
      model_class_name = name.to_s.capitalize
    end

    Object.module_eval <<-EOE, __FILE__, __LINE__
      class #{model_class_name} < Ohm::Model
        index :id
        alias :save! :save
      end
    EOE

    const_get(model_class_name).class_eval do
      Factory.factories[name].attributes.each do |attr|
        attribute attr.name.to_sym
        index attr.name.to_sym
      end
    end
  end
end

require 'factory_girl'