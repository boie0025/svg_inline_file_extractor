require "svg_inline_file_extractor/version"
require "svg_inline_file_extractor/svg_file"
require "svg_inline_file_extractor/inline_image"

module SvgInlineFileExtractor
  class MiniMagickMissing < StandardError; end

  # @param [ String ] xml_string should be a full raw SVG file
  # @return [ Array<String> ] an array of binary strings containing the images in the SVG file
  def self.binary_images(xml_string)
    SvgFile.binary_images(xml_string)
  end

  # @param [ String ] xml_string should be a full raw SVG file
  # @return [ Array<InlineImage> ] an array of the inline images found in the document
  # @see InlineImage
  def self.inline_images(xml_string)
    SvgFile.inline_images(xml_string)
  end

  # @param [ String ] uri a URI to open and identify.
  # @return [ String | Nil ] image type determined by MiniMagick.
  # @note will return nil if MiniMagick is not present
  def self.identify_image(uri)
    if use_mini_magick?
      return with_temp_image(uri) do |temp_image|
        MiniMagick::Image.open(temp_image).type.downcase
      end
    end
  end

  # @return [ Boolean ] true if MiniMagick is found, false if not.
  def self.use_mini_magick?
    Object.const_defined?('MiniMagick::Image')
  end

  # do something with a temporary copy of uri in a block.
  # @param [ String ] uri - the location of the file to open into a temp file. 
  def self.with_temp_image(uri)
    temp = Tempfile.new
    temp.binmode
    puts "opening #{uri}"
    temp.write open(uri).binmode.read
    temp.close
    results = yield temp.path
    temp.delete
    results
  end

end
