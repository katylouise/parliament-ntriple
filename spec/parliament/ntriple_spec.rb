require_relative '../spec_helper'

RSpec.describe Parliament::NTriple do
  describe '.load!' do
    context 'with a missing requirement' do
      context '::Parliament::Response' do
        it 'raises a LoadError' do
          allow(described_class).to receive(:parliament_response?).and_return(false)

          expect{ described_class.load! }.to raise_error(LoadError, "Missing requirement 'Parliament::Response'. Have you added `gem 'parliament-ruby'` to your Gemfile?")
        end
      end

      context '::Parliament::Builder' do
        it 'raises a LoadError' do
          allow(described_class).to receive(:parliament_builder?).and_return(false)

          expect{ described_class.load! }.to raise_error(LoadError, "Missing requirement 'Parliament::Builder'. Have you added `gem 'parliament-ruby'` to your Gemfile?")
        end
      end
    end
  end
end