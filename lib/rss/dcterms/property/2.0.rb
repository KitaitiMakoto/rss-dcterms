require 'rss/2.0'

module RSS
  Rss.install_ns(DCTERMS::PREFIX, DCTERMS::URI)

  class Rss
    class Channel
      include DCTERMS::PropertyModel
      class Item; include DCTERMS::PropertyModel; end
    end
  end
end
