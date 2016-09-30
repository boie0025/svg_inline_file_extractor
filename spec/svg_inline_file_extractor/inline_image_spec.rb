require 'spec_helper'

module SvgInlineFileExtractor

  describe InlineImage do
    describe '#declared_image_type' do
      let(:nokogiri_element) { double(:nokogiri_element, value: href_contents) }
      subject { described_class.new(nokogiri_element).declared_image_type }

      context 'jpeg' do
        let(:href_contents) { "data:image/jpeg;base64,..." }
        it { is_expected.to eq 'jpeg' }
      end

      context 'JPG' do
        let(:href_contents) { "data:image/jpg;base64,..." }
        it { is_expected.to eq 'jpg' }
      end

      context 'PNG' do
        let(:href_contents) { "data:image/png;base64,..." }
        it { is_expected.to eq 'png' }
      end

      context 'OTHER' do
        let(:href_contents) { "data:image/zebra;base64,..." }
        it { is_expected.to eq 'zebra' }
      end

      context 'NON Image' do
        let(:href_contents) { "http://www.example.com/image.png" }
        it { is_expected.to be_nil }
      end
    end

    describe '#inline_image?' do
      let(:nokogiri_element) { double(:nokogiri_element, value: href_contents) }
      subject { described_class.new(nokogiri_element) }

      context 'href contents match the header pattern' do
        let(:href_contents) { "data:image/zebra;base64,..." }
        it { is_expected.to be_inline_image }
      end

      context 'href contents do not match header pattern' do
        let(:href_contents) { "http://www.example.com/image.png" }
        it { is_expected.to_not be_inline_image }
      end

    end

    context 'with svg file' do
      let(:svg) { File.read(File.expand_path('../../fixtures/ruby-logo.svg', __FILE__)) }
      let(:nokogiri) { Nokogiri::XML(svg).remove_namespaces! }
      let(:nokogiri_element) { nokogiri.xpath("//image/@href").first }
      subject { described_class.new(nokogiri_element) }

      describe '#element_id' do
        subject { super().element_id }
        it { is_expected.to eq 'image3551' }
      end

      describe '#element_class' do
        subject { super().element_class }
        it { is_expected.to eq nil } # class not set.
      end

      describe '#get_attribute' do
        subject { super().get_attribute('width')}
        it { is_expected.to eq '81' } #width from the logo file's first png element.
      end

      describe '#svg_href_contents=' do
        it 'sets the contents of the href' do
          subject.svg_href_contents = 'http://example.com/image.png'
          expect(nokogiri.xpath("//image/@href").first.value).to eq 'http://example.com/image.png'
        end
      end
    end

  end
end
