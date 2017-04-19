require_relative '../../spec_helper'

describe Parliament::Builder::NTripleResponseBuilder, vcr: true do
  let(:person_id) { '80c2b596-494f-4dab-97ed-867729a40451' }
  let(:parliament_response) { Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030').people(person_id).get }

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
end