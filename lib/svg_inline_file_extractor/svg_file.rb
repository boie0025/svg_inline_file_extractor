require 'nokogiri'
require 'base64'

module SvgInlineFileExtractor
  class SvgFile

    class << self
      # @param [ String ] xml_string should be a full raw SVG file
      def binary_images(xml_string)
        new(xml_string).binary_images
      end

      # @param [ String ] xml_string should be a full raw SVG file
      def inline_images(xml_string)
        new(xml_string).inline_images
      end
    end

    attr_accessor :xml_string

    # @param [ String ] xml_string should be a full raw SVG file
    def initialize(xml_string)
      self.xml_string = xml_string
    end

    # @return [ Array<String> ] an array of binary strings containing the images in the SVG file
    def binary_images
      inline_images.map(&:binary_image)
    end

    # @return [ Nokogiri::XML ] a nokogiri XML document wrapper
    def nokogiri_document
      @nokogiri_document ||= begin
        doc = Nokogiri::XML(xml_string, nil, nil, Nokogiri::XML::ParseOptions::HUGE)
        doc
      end
    end

    # @param [ Boolean ] false returns only inline base64 encoded images, true returns all image tags
    # @return [ Array<InlineImage> ] an array of the inline images found in the document
    # @see InlineImage
    def inline_images(all = false)
      image_elements.map do |element|
        image = InlineImage.new(element)
        if all || image.inline_image?
          image
        end
      end.compact
    end

    # @return the rendered nokogiri_document.
    # @note text "&#10;" will be replaced with newlines to allow newlines in Base64
    #   encoded strings.
    def rendered_svg
      nokogiri_document.to_s.gsub('&#10;', "\n")
    end

    private

    def image_elements
      @image_elements ||= nokogiri_document.xpath("//svg:image/@xlink:href", 'svg' => 'http://www.w3.org/2000/svg', 'xlink' => 'http://www.w3.org/1999/xlink')
    end

  end
end
