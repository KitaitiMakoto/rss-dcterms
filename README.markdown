RSS::DCTerms
============

Enables standard bundled RSS library parse and make feeds including DCMI Metadata Terms.

Installation
------------

Add this line to your application's Gemfile:

    gem 'rss-dcterms'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rss-dcterms

Or

    $ ruby setup.rb

Usage
-----

### Parsing Feeds

    require 'rss/dcterms'

    feed = RSS::Parser.parse(feed_uri)
    publisher = feed.dcterms_publisher

### Making Feeds

    require 'rss/maker/dcterms'

    feed = RSS::Maker.make('atom') {|maker|
        maker.channel.dcterms_issued = Time.now
        # ...
    }

Todo
----

* Turn off DC(http://purl.org/dc/elements/1.1/) elements when making feeds

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Merge Request
