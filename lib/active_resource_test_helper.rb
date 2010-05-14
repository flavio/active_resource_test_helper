require 'active_resource_test_helper/ohm/model'
require 'active_resource_test_helper/active_resource/http_mock'
require 'active_resource_test_helper/factory'

module ActiveResourceTestHelper
  def self.included(base)
    base.extend ClassMethods
  end

  def run(*args, &block)
    ActiveResource::HttpMock.dynamic_models.each do |model|
      model.destroy_all
    end

    super(*args, &block)

    ActiveResource::HttpMock.dynamic_models.each do |model|
      model.destroy_all
    end
  end

  module ClassMethods
    def active_resource_factories *args
      args.each do |name|
        ActiveResource::HttpMock.register_factory name
      end
    end
  end
end
