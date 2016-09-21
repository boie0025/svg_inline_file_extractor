require 'spec_helper'

module SvgInlineFileExtractor
  describe SvgFile do
    let(:xml_string) { File.read(File.expand_path('../../fixtures/ruby-logo.svg', __FILE__)) }

    describe '#nokogiri_document' do
      subject { described_class.new(xml_string).nokogiri_document }
      it { is_expected.to be_a Nokogiri::XML::Document }
    end

    describe '#binary_images' do
      subject { described_class.new(xml_string).binary_images }
      it { is_expected.to_not be_empty }
      it { is_expected.to be_an Array }
      context 'first image' do
        subject { super()[0] }
        it { is_expected.to_not start_with('data:image/png;base64,')}
      end
    end
  end
end
