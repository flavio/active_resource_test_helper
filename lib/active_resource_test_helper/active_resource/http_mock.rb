require "active_resource"
require "active_resource/http_mock"
require "active_support"
require 'cgi'

module ActiveResource # :nodoc:

  # Adds new convenience methods to ActiveResource::HttpMock[http://api.rubyonrails.org/classes/ActiveResource/HttpMock.html].
  class HttpMock
    # Return a list of all the dynamic models used by HttpMock
    def self.dynamic_models
      @@dynamic_models ||= []
    end

    # Add a new dynamic model by registering a new factory.
    # Do not use this method directly, Use the active_resource_factories method
    # provided by the ActiveResourceTestHelper module.
    def self.register_factory name
      build_class = Factory.factory_by_name(name).build_class
      dynamic_models << build_class unless dynamic_models.include? build_class
    end

    # Unregister all the dynamic models.
    def reset_dynamic_models!
      @@dynamic_models.clear
    end

    alias old_get get
    
    def get(path, headers) #:nodoc:
      begin
        # lookup into the static mocks
        old_get path, headers
      rescue InvalidRequestError
        # lookup into the dynamic mocks
        model_class = HttpMock.dynamic_models.find{|m| !(path =~ dynamic_model_regexp(m)).nil?}
        if model_class.nil?
          raise
        else
          if $1.nil? and $2.nil?
            # all the items have been requested
            items = entries_to_valid_array(model_class.all)
            response = Response.new(items.to_xml(:root => model_class.to_s))
          elsif !$1.nil?
            # a specific item has been requested
            match = model_class.find(:id => $1.delete('/').to_i).entries.first

            if match.nil?
              response = Response.new(nil, 404)
            else
              response = Response.new(match.to_hash.to_xml(:root => model_class.to_s))
            end
          else
            # query contains params
            params = {}
            CGI::parse($2[1,$2.size]).each do |key, value|
              params[key.to_sym] = value.first
            end
            items = entries_to_valid_array(model_class.find(params).entries)
            response = Response.new(items.to_xml(:root => model_class.to_s))
          end
          self.class.responses << response
          response
        end
      end
    end

    private
    def dynamic_model_regexp model # :nodoc:
      /\/#{model.to_s.underscore.pluralize}(\/\d+)?\.xml(\?.*)?/
    end

    def entries_to_valid_array entries# :nodoc:
      entries.sort{|a,b| a.id.to_i <=> b.id.to_i}.map{|i| i.to_hash}
    end
  end
end