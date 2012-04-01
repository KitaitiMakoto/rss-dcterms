require 'rss/atom'

module RSS
  module Atom
    Feed.install_ns(DCTERMS::PREFIX, DCTERMS::URI)

    class Feed
      include DCTERMS::PropertyModel
      class Entry; include DCTERMS::PropertyModel; end
    end

    class Entry
      include DCTERMS::PropertyModel
    end
  end
end
