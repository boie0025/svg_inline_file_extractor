require 'spec_helper'

module SvgInlineFileExtractor
  describe SvgFile do
    let(:svg) { File.read(File.expand_path('../../fixtures/ruby-logo.svg', __FILE__)) }
    let(:ruby_triangle) { File.binread(File.expand_path('../../fixtures/ruby-triangle.png', __FILE__)) }
    let(:ruby_circle) { File.binread(File.expand_path('../../fixtures/ruby-circle.png', __FILE__)) }

    describe '#nokogiri_document' do
      subject { described_class.new(svg).nokogiri_document }
      it { is_expected.to be_a Nokogiri::XML::Document }
    end

    describe '#binary_images' do
      subject { described_class.new(svg).binary_images }
      it { is_expected.to_not be_empty }
      it { is_expected.to be_an Array }
      context 'first image' do
        subject { super()[0] }
        it { is_expected.to_not start_with('data:image/png;base64,')}
      end
    end

    describe '.inline_images' do
      subject { described_class.inline_images(svg) }
      it { is_expected.to be_an(Array) }
      it { is_expected.to include(InlineImage, InlineImage) }

      it 'extracts the triangle png' do
        expect(subject.first.binary_image).to eq ruby_triangle
      end

      it 'extracts the circle png' do
        expect(subject.last.binary_image).to eq ruby_circle
      end
    end


  end
end
