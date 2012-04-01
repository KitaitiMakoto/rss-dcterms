# RSS::DCTERMS

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'rss-dcterms'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rss-dcterms

Or

    $ ruby setup.rb

## Usage

    require 'rss/dcterms'

    feed = RSS::Parser.parse(feed_uri)
    publisher = feed.dcterms_publisher

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Merge Request
