require 'spec_helper'

describe SvgInlineFileExtractor do
  it 'has a version number' do
    expect(SvgInlineFileExtractor::VERSION).not_to be nil
  end

  let(:svg) { File.read(File.expand_path('../fixtures/ruby-logo.svg', __FILE__)) }

  describe '.binary_images' do
    context 'svg file with two inline PNG images' do
      subject { described_class.binary_images(svg) }
      it { is_expected.to be_an Array }
      it 'returns an array of decoded binary PNGs' do
        expect(subject).to include(String, String)
      end
    end
  end

  describe '.inline_images' do
    context 'svg file with two inline PNG images' do
      subject { described_class.inline_images(svg) }
      it { is_expected.to be_an Array }
      it 'returns an array of InlineImage objects' do
        expect(subject).to include(SvgInlineFileExtractor::InlineImage, SvgInlineFileExtractor::InlineImage)
      end
    end
  end
end
