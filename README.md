# SvgInlineFileExtractor
[![Build Status](https://travis-ci.org/boie0025/svg_inline_file_extractor.svg?branch=master)](https://travis-ci.org/boie0025/svg_inline_file_extractor)
[![Test Coverage](https://codeclimate.com/github/boie0025/svg_inline_file_extractor/badges/coverage.svg)](https://codeclimate.com/github/boie0025/svg_inline_file_extractor/coverage)
[![Code Climate](https://codeclimate.com/github/boie0025/svg_inline_file_extractor/badges/gpa.svg)](https://codeclimate.com/github/boie0025/svg_inline_file_extractor)


The purpose of this gem is to extract inline SVG base64 encoded PNG images. This is based in part from ideas in https://gist.github.com/r10r/2822884

This is a work in progress.

## Roadmap

* Add ability to replace an inline image with a URI after extraction
* Extract svg_file image handling to a separate class
* Work with more than just PNG files
* Query images for their type, possibly other meta

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'svg_inline_file_extractor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install svg_inline_file_extractor

## Usage

```ruby
require 'svg_inline_file_extractor'

# open a file
# set path to an SVG file (example file in the gem under spec/fixtures)
# path = <PATH TO SOME SVG FILE WITH INLINE IMAGES>
files = SvgInlineFileExtractor.binary_images(path: path)

# Write FIRST image to a tempfile
tf = Tempfile.new(['file','.png'])
tf.write(files.first)
tf.close

#open the file
`open #{tf.path}`

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/boie0025/svg_inline_file_extractor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
