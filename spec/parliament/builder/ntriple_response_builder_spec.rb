require_relative '../../spec_helper'

describe Parliament::Builder::NTripleResponseBuilder, vcr: true do
  let(:person_id) { '80c2b596-494f-4dab-97ed-867729a40451' }
  let(:parliament_response) { Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030').people(person_id).get }
  let(:ntriple_response_body) { "\xEF\xBB\xBF<https://id.parliament.uk/d3Sii84i> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <https://id.parliament.uk/schema/ConstituencyGroup> .\r\n" }

  subject { Parliament::Builder::NTripleResponseBuilder.new(response: parliament_response.response) }

  context 'build' do
    before(:each) do
      @ntriple_response = subject.build
    end

    it 'returns a Parliament::Response::NTripleResponse object' do
      expect(@ntriple_response).to be_a(Parliament::Response::NTripleResponse)
    end

    it 'returns 9 objects' do
      expect(@ntriple_response.size).to eq(9)
    end

    it 'returns an array of Grom::Node objects' do
      @ntriple_response.each do |object|
        expect(object).to be_a(Grom::Node)
      end
    end
  end

  context 'encode_to_utf8' do
    before(:each) do
      @ascii_ntriple_response_body = ntriple_response_body.force_encoding('ASCII-8BIT')
    end

    it 'converts an ASCII-8BIT response to UTF-8' do
      expect(subject.send(:encode_to_utf8, @ascii_ntriple_response_body).encoding.name).to eq('UTF-8')
    end
  end

  context 'remove_byte_order_mark' do
    before(:each) do
      @utf8_ntriple_response_body = ntriple_response_body.force_encoding('UTF-8')
    end

    it 'replaces byte order mark with empty string' do
      expect(subject.send(:remove_byte_order_mark, @utf8_ntriple_response_body)).not_to include("\xEF\xBB\xBF")
      expect(subject.send(:remove_byte_order_mark, @utf8_ntriple_response_body)).not_to eq("\xEF\xBB\xBF<https://id.parliament.uk/d3Sii84i> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <https://id.parliament.uk/schema/ConstituencyGroup> .\r\n")
    end
  end
end
