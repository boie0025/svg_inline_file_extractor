require 'nokogiri'
require 'base64'

module SvgInlineFileExtractor
  class SvgFile

    class << self
      def from_path(path)
        string = File.read(path)
        new(string)
      end

      def from_string(string)
        new(string)
      end

      def strip_header_from(string)
        string.gsub(/data:image\/...;base64\,/, '')
      end
    end

    attr_accessor :xml_string

    def initialize(xml_string)
      self.xml_string = xml_string
    end

    def nokogiri_document
      @nokogiri_document ||= begin
        doc = Nokogiri::XML(xml_string)
        doc.remove_namespaces!
        doc
      end
    end

    def binary_images
      image_elements.map do |element|
        image_string = element.value
        image_string = self.class.strip_header_from(image_string)
        Base64.decode64(image_string)
      end
    end

    private

    def image_elements
      @image_elements ||= nokogiri_document.xpath("//image/@href")
    end

  end
end
