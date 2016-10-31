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

  describe '.identify_image' do
    let(:ruby_circle) { File.expand_path('../fixtures/ruby-circle.png', __FILE__) }
    let(:minimagick_image) { double(:minimagick_image) }
    before do
      minimagick_image.stub_chain(:open, :type, :downcase).and_return('png')
      MiniMagick = Module.new
      MiniMagick::Image = minimagick_image
      #allow(subject).to receive(:use_mini_magick?).and_return true
    end

    it 'opens the URI and tries to identify the file' do
      expect(subject.identify_image(ruby_circle)).to eq 'png'
    end
  end
end
