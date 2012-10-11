require 'rss/1.0'

module RSS
  RDF.install_ns(DCTERMS::PREFIX, DCTERMS::URI)

  class RDF
    class Channel; include DCTERMS::PropertyModel; end
    class Image; include DCTERMS::PropertyModel; end
    class Item; include DCTERMS::PropertyModel; end
    class Textinput; include DCTERMS::PropertyModel; end
  end
end
