require 'base64'
require 'open-uri'

module SvgInlineFileExtractor
  class InlineImage

    # Regex pattern to match against the beginning of the href string.  the type, if found, will be the raw string, eg: jpeg, jpg, png, etc.
    DATA_IMAGE_HEADER_PATTERN = /data:image\/(?<type>.+);base64\,/.freeze

    # @attr [ String ] href_contents The value extracted from the nokogiri_element (href).  May be binary.
    # @attr [ Nokogiri::XML::Attr ] nokogiri_element the href node from the SVG file
    attr_accessor :href_contents, :nokogiri_element

    # @param [ Nokogiri::XML::Attr ] nokogiri_element the href node from the SVG file
    def initialize(nokogiri_element)
      self.nokogiri_element = nokogiri_element
      self.href_contents = nokogiri_element.value
    end

    # @return [ String|Nil ] The image type according to the DATA_IMAGE_HEADER_PATTERN, nil if pattern not matched.
    def declared_image_type
      @declared_image_type ||= begin
        if (match = href_contents.match(DATA_IMAGE_HEADER_PATTERN))
          match[:type]
        end
      end
    end

    # @return [ Boolean ] true if declared_image_type is not nil
    def inline_image?
      !!declared_image_type
    end

    # @return [ String | nil ] the value of the id attribute in the parent element
    def element_id
      @element_id ||= get_attribute('id')
    end

    # @return [ String | nil ] the value of the class attribute in the parent element
    def element_class
      @element_class ||= get_attribute('class')
    end

    # @param [ String ] attribute an attribute to retreive from the parent element (the entity that this href came from)
    # @return [ String | Nil ] the value in the specified attribute, or nil if not set
    def get_attribute(attribute)
      attribute = nokogiri_element.parent.attribute(attribute)
      attribute.value if attribute
    end

    # Updates the contents of the href that this inline image came from,
    #  and #href_contents
    # @param [ String ] value the value to set the href contents to
    def href_contents=(value)
      @href_contents = value
      nokogiri_element.value = value
    end

    # @return [ String ] Base64 decoded binary image from href
    # @note I'm not sure if memoization is the best here, let's see what happens in the wild.
    def binary_image
      @binary_image ||= Base64.decode64(without_header)
    end

    # If the image href is set to a URI, attempt to download/open and convert to an
    #  base64 encoded inline image
    # @return [ Boolean ] true
    # @raise [ SvgInlineFileExtractor::MiniMagickMissing ] if MiniMagick is not installed/required.
    def set_binary_image_from_uri!
      unless SvgInlineFileExtractor.use_mini_magick?
        raise MiniMagickMissing, '#set_binary_image_from_uri! requires the MiniMagick gem to be installed.'
      end
      SvgInlineFileExtractor.with_temp_image(nokogiri_element.value) do |temp_image|
        format = SvgInlineFileExtractor.identify_image(temp_image).to_s.downcase
        nokogiri_element.value = "data:image/#{format};base64,#{encode(temp_image)}"
        nokogiri_element.name = 'href'
      end
      true
    end

    private

    def encode(image_path)
      Base64.encode64(File.open(image_path.to_s).binmode.read)
    end

    def without_header
      @without_header ||= href_contents.gsub(DATA_IMAGE_HEADER_PATTERN, '')
    end

  end
end
