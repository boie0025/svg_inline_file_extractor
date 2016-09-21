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
        expect(subject)
      end
    end
  end
end
