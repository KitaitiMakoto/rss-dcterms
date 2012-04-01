require 'rss'

module RSS
  module DCTERMS
    PREFIX = 'dcterms'
    URI = "http://purl.org/dc/terms/"
  end

  module Utils
    module_function

    def to_attr_name(name)
      name.gsub(/([A-Z])/) {'_' + $1.downcase}
    end
  end
end

require 'rss/dcterms/property'
