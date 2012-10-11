require 'rss/2.0'

module RSS
  Rss.install_ns(DCTerms::PREFIX, DCTerms::URI)

  class Rss
    class Channel
      include DCTerms::PropertyModel
      class Item; include DCTerms::PropertyModel; end
    end
  end
end
