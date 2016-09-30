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
        doc = Nokogiri::XML(xml_string)
        doc.remove_namespaces!
        doc
      end
    end

    # @return [ Array<InlineImage> ] an array of the inline images found in the document
    # @see InlineImage
    def inline_images
      image_elements.map do |element|
        if (image = InlineImage.new(element)).inline_image?
          image
        end
      end.compact
    end

    private

    def image_elements
      @image_elements ||= nokogiri_document.xpath("//image/@href")
    end

  end
end
