require "svg_inline_file_extractor/version"
require "svg_inline_file_extractor/svg_file"

module SvgInlineFileExtractor
  def self.binary_images(path: nil, xml: nil)
    raise ArgumentError.new("Specify a path: [full path], or xml: [SVG String]") unless (path || xml)
    raise ArgumentError.new("Specify either a path: [full path], or xml: [SVG String]") if (path && xml)
    return SvgFile.from_path(path).binary_images if path
    return SvgFile.from_string(xml).binary_images if xml
  end
end
