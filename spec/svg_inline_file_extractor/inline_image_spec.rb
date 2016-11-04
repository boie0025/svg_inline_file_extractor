require 'spec_helper'

module SvgInlineFileExtractor

  describe InlineImage do
    describe '#declared_image_type' do
      let(:nokogiri_element) { double(:nokogiri_element, value: href_contents, "value=" => nil) }
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
      let(:nokogiri_element) { double(:nokogiri_element, value: href_contents, "value=" => nil) }
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

      describe '#href_contents=' do
        it 'sets the contents of the href' do
          subject.href_contents = 'http://example.com/image.png'
          expect(nokogiri.xpath("//image/@href").first.value).to eq 'http://example.com/image.png'
        end
      end

      describe '#set_binary_image_from_uri!' do
        context 'no mini_magick' do
          it 'raises an exception' do
            expect{ subject.set_binary_image_from_uri! }.to raise_error(MiniMagickMissing)
          end
        end
        context 'with mini_magick' do
          let(:href_contents) { 'https://example.com/image.png' }
          before do
            allow(SvgInlineFileExtractor).to receive(:use_mini_magick?).and_return(true)
            allow(SvgInlineFileExtractor).to receive(:identify_image).with(anything).and_return 'png'
            allow(SvgInlineFileExtractor).to receive(:with_temp_image).and_yield('')
            allow(subject).to receive(:encode).and_return('base64 string')
            subject.nokogiri_element.value = href_contents
            subject.nokogiri_element.name = 'href'
          end

          it 'sets the value of the element to the encoded data' do
            expect{ subject.set_binary_image_from_uri! }
              .to change{ subject.nokogiri_element.value }
              .from(href_contents)
              .to('data:image/png;base64,base64 string')
          end


          it 'sets the name of the attribute to xlink:href' do
            expect{ subject.set_binary_image_from_uri! }
              .to_not change{ subject.nokogiri_element.name }
          end
        end

        describe '#encode' do
          let(:binary_file) { File.expand_path('../../fixtures/ruby-circle.png', __FILE__) }
          it 'encodes the string' do
            # pre-calculated size of the PNG file after base64 encoding
            expect(subject.send(:encode, binary_file).size).to eq 7_304
          end
        end

      end
    end

  end
end
