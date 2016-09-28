require "svg_inline_file_extractor/version"
require "svg_inline_file_extractor/svg_file"
require "svg_inline_file_extractor/inline_image"

module SvgInlineFileExtractor

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
  
end
