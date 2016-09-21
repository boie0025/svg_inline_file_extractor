require "svg_inline_file_extractor/version"
require "svg_inline_file_extractor/svg_file"

module SvgInlineFileExtractor
  def self.binary_images(string)
    SvgFile.binary_images(string)
  end
end
