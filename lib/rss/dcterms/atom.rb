require 'rss/atom'

module RSS
  module Atom
    Feed.install_ns(DCTerms::PREFIX, DCTerms::URI)

    class Feed
      include DCTerms::PropertyModel
      class Entry; include DCTerms::PropertyModel; end
    end

    class Entry
      include DCTerms::PropertyModel
    end
  end
end
