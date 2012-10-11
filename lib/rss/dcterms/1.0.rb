require 'rss/1.0'

module RSS
  RDF.install_ns(DCTerms::PREFIX, DCTerms::URI)

  class RDF
    class Channel; include DCTerms::PropertyModel; end
    class Image; include DCTerms::PropertyModel; end
    class Item; include DCTerms::PropertyModel; end
    class Textinput; include DCTerms::PropertyModel; end
  end
end
