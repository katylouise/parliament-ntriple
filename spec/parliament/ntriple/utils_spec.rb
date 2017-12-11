# -*- coding: utf-8 -*-
require_relative '../../spec_helper'

describe Parliament::NTriple::Utils, vcr: true do
  describe '#sort_by' do
    context 'all nodes have the parameter being sorted on' do
      it 'returns a response sorted by personFamilyName' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people.get

        sorted_people = Parliament::NTriple::Utils.sort_by({
                                                      list: response.nodes,
                                                      parameters: [:personFamilyName]
                                                  })

        expect(sorted_people.first.personGivenName).to eq('Jane')
      end

      it 'returns a response sorted by seatIncumbencyStartDate' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people('2c196540-13f3-4c07-8714-b356912beceb').get
        filtered_response = response.filter('http://id.ukpds.org/schema/SeatIncumbency')

        sorted_incumbencies = Parliament::NTriple::Utils.sort_by({
                                                            list: filtered_response.nodes,
                                                            parameters: [:parliamentaryIncumbencyStartDate]
                                                        })

        expect(sorted_incumbencies.first.parliamentaryIncumbencyStartDate).to eq('1987-06-11')
        expect(sorted_incumbencies[1].parliamentaryIncumbencyStartDate).to eq('1992-04-09')
      end
    end

    context 'not all nodes have the parameter being sorted on' do
      it 'returns a response sorted by personGivenName' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder,
                                                       decorators: Parliament::Grom::Decorator).people.get

        sorted_people = Parliament::NTriple::Utils.sort_by({
                                                      list: response.nodes,
                                                      parameters: [:personGivenName]
                                                  })

        expect(sorted_people.first.given_name).to eq('')
        expect(sorted_people[1].given_name).to eq('Alice')
      end

      it 'returns a response sorted by end_date (it can handle nil values)' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder,
                                                       decorators: Parliament::Grom::Decorator).people('1921fc4a-6867-48fa-a4f4-6df05be005ce').get
        person = response.filter('http://id.ukpds.org/schema/Person').first

        sorted_incumbencies = Parliament::NTriple::Utils.sort_by({
                                                            list: person.incumbencies,
                                                            parameters: [:end_date],
                                                            prepend_rejected: false
                                                                 })

        expect(sorted_incumbencies.last.end_date).to eq(nil)
        expect(sorted_incumbencies[sorted_incumbencies.length - 2].end_date).to eq(DateTime.new(2015, 3, 30))
      end

      it 'uses the prepend_rejected parameter correctly - defaults to true so nil values will be at the start' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder,
                                                       decorators: Parliament::Grom::Decorator).people('1921fc4a-6867-48fa-a4f4-6df05be005ce').get
        person = response.filter('http://id.ukpds.org/schema/Person').first

        sorted_incumbencies = Parliament::NTriple::Utils.sort_by({
                                                            list: person.incumbencies,
                                                            parameters: [:end_date]
                                                        })

        expect(sorted_incumbencies.first.end_date).to be(nil)
      end

      it 'uses the prepend_rejected parameter correctly - when set to false the nil values will be at the end' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder,
                                                       decorators: Parliament::Grom::Decorator).people('1921fc4a-6867-48fa-a4f4-6df05be005ce').get
        person = response.filter('http://id.ukpds.org/schema/Person').first

        sorted_incumbencies = Parliament::NTriple::Utils.sort_by({
                                                            list: person.incumbencies,
                                                            parameters: [:end_date],
                                                            prepend_rejected: false
                                                        })

        expect(sorted_incumbencies.last.end_date).to be(nil)
      end
    end

    context 'sorting by multiple parameters' do
      it 'returns a response sorted by personFamilyName, then personGivenName' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people.get

        sorted_people = Parliament::NTriple::Utils.sort_by({
                                                      list: response.nodes,
                                                      parameters: [:personFamilyName, :personGivenName]
                                                  })

        expect(sorted_people.first.personGivenName).to eq('Rebecca')
        expect(sorted_people[1].personGivenName).to eq('Sarah')
      end
    end

    context 'sorting strings of different cases' do
      it 'returns a response sorted by personFamilyName' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people.get

        sorted_people = Parliament::NTriple::Utils.sort_by({
                                                      list: response.nodes,
                                                      parameters: [:personFamilyName]
                                                  })

        expect(sorted_people.first.personGivenName).to eq('Jane')
        expect(sorted_people[1].personGivenName).to eq('Alice')
      end
    end

    context 'sorting strings with accents' do
      it 'returns a response sorted by personGivenName' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people.get

        sorted_people = Parliament::NTriple::Utils.sort_by({
                                                      list: response.nodes,
                                                      parameters: [:personGivenName]
                                                  })

        expect(sorted_people.first.personGivenName).to eq('Sarah')
        expect(sorted_people[1].personGivenName).to eq('Sóley')
        expect(sorted_people[2].personGivenName).to eq('Solomon')
      end

      it 'returns a response sorted by personFamilyName, personGivenName' do
        response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                       builder: Parliament::Builder::NTripleResponseBuilder).people.get

        sorted_people = Parliament::NTriple::Utils.sort_by({
                                                      list: response.nodes,
                                                      parameters: [:personFamilyName, :personGivenName]
                                                  })

        expect(sorted_people.first.personGivenName).to eq('Solomon')
        expect(sorted_people[1].personGivenName).to eq('Sophie')
        expect(sorted_people[2].personGivenName).to eq('Sarah')
      end
    end
  end

  describe '#reverse_sort_by' do
    it 'returns a response sorted by parliamentaryIncumbencyStartDate' do
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder,
                                                     decorators: Parliament::Grom::Decorator).people('2c196540-13f3-4c07-8714-b356912beceb').get
      person = response.filter('http://id.ukpds.org/schema/Person').first

      sorted_incumbencies = Parliament::NTriple::Utils.reverse_sort_by({
                                                                  list: person.incumbencies,
                                                                  parameters: [:start_date]
                                                              })

      expect(sorted_incumbencies[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(sorted_incumbencies[1].start_date).to eq(DateTime.new(2010, 5, 6))
    end

    it 'returns a response sorted by end_date (it can handle nil values)' do
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder,
                                                     decorators: Parliament::Grom::Decorator).people('1921fc4a-6867-48fa-a4f4-6df05be005ce').get
      person = response.filter('http://id.ukpds.org/schema/Person').first

      sorted_incumbencies = Parliament::NTriple::Utils.reverse_sort_by({
                                                                  list: person.incumbencies,
                                                                  parameters: [:end_date],
                                                                  prepend_rejected: false
                                                              })

      expect(sorted_incumbencies.first.end_date).to be(nil)
      expect(sorted_incumbencies[1].end_date).to eq(DateTime.new(2015, 3, 30))
    end
  end

  describe '#multi_direction_sort' do
    it 'returns a response sorted by member_count (desc) and name (asc)' do
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder,
                                                     decorators: Parliament::Grom::Decorator).houses('mG2ur5TF').parties.current.get
      filtered_response = response.filter('http://id.ukpds.org/schema/Party')

      sorted_parties = Parliament::NTriple::Utils.multi_direction_sort({
                                                                    list: filtered_response.nodes,
                                                                    parameters: { member_count: :desc, name: :asc },
                                                                       })

      expect(sorted_parties.first.name).to eq('Conservative')
      expect(sorted_parties[10].name).to eq('Green Party')
      expect(sorted_parties[11].name).to eq('Independent Social Democrat')
      expect(sorted_parties[12].name).to eq('Independent Ulster Unionist')
      expect(sorted_parties[13].name).to eq('Plaid Cymru')
    end

    it 'returns a response sorted by member_count (asc) and name (asc)' do
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder,
                                                     decorators: Parliament::Grom::Decorator).houses('mG2ur5TF').parties.current.get
      filtered_response = response.filter('http://id.ukpds.org/schema/Party')

      sorted_parties = Parliament::NTriple::Utils.multi_direction_sort({
                                                                           list: filtered_response.nodes,
                                                                           parameters: { member_count: :asc, name: :asc },
                                                                       })

      expect(sorted_parties[0].name).to eq('Green Party')
      expect(sorted_parties[1].name).to eq('Independent Social Democrat')
      expect(sorted_parties[2].name).to eq('Independent Ulster Unionist')
      expect(sorted_parties[3].name).to eq('Plaid Cymru')
      expect(sorted_parties.last.name).to eq('Conservative')
    end

    it 'returns a response sorted by member_count (desc) and name (desc)' do
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder,
                                                     decorators: Parliament::Grom::Decorator).houses('mG2ur5TF').parties.current.get
      filtered_response = response.filter('http://id.ukpds.org/schema/Party')

      sorted_parties = Parliament::NTriple::Utils.multi_direction_sort({
                                                                           list: filtered_response.nodes,
                                                                           parameters: { member_count: :desc, name: :desc },
                                                                       })

      expect(sorted_parties.first.name).to eq('Conservative')
      expect(sorted_parties[13].name).to eq('Green Party')
      expect(sorted_parties[12].name).to eq('Independent Social Democrat')
      expect(sorted_parties[11].name).to eq('Independent Ulster Unionist')
      expect(sorted_parties[10].name).to eq('Plaid Cymru')
    end

    it 'returns a response sorted by date of birth (desc), given_name (asc) and family_name (desc)' do
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder,
                                                     decorators: Parliament::Grom::Decorator).people.members.current('a').get
      filtered_response = response.filter('http://id.ukpds.org/schema/Person')

      sorted_people = Parliament::NTriple::Utils.multi_direction_sort({
                                                                           list: filtered_response.nodes,
                                                                           parameters: { date_of_birth: :asc,
                                                                                         given_name: :asc,
                                                                                         family_name: :desc
                                                                           },
                                                                       })

      expect(sorted_people.first.given_name).to eq('Katherine')
      expect(sorted_people[1].given_name).to eq('Rebecca')
      expect(sorted_people[2].given_name).to eq('Anne')
      expect(sorted_people[3].given_name).to eq('Emma')
      expect(sorted_people[3].family_name).to eq('Turquoise')
      expect(sorted_people[4].given_name).to eq('Emma')
      expect(sorted_people[4].family_name).to eq('Silver')
      expect(sorted_people[5].given_name).to eq('Emma')
      expect(sorted_people[5].family_name).to eq('Arwen')
    end

    it 'sorts with a large number of filters' do
      response = Parliament::Request::UrlRequest.new(base_url: 'http://localhost:3030',
                                                     builder: Parliament::Builder::NTripleResponseBuilder,
                                                     decorators: Parliament::Grom::Decorator).people.members.current('a').get
      filtered_response = response.filter('http://id.ukpds.org/schema/Person')

      sorted_people = Parliament::NTriple::Utils.multi_direction_sort({
                                                                          list: filtered_response.nodes,
                                                                          parameters: { date_of_birth: :asc,
                                                                                        name1: :asc,
                                                                                        name2: :desc,
                                                                                        name3: :asc,
                                                                                        name4: :desc
                                                                          },
                                                                      })

      expect(sorted_people[0].name1).to eq('E')
      expect(sorted_people[1].name1).to eq('S')
      expect(sorted_people[2].name1).to eq('K')
      expect(sorted_people[3].name1).to eq('R')
      expect(sorted_people[4].name2).to eq('F')
      expect(sorted_people[5].name2).to eq('E')
      expect(sorted_people[6].name3).to eq('A')
      expect(sorted_people[7].name3).to eq('B')
      expect(sorted_people[8].name4).to eq('O')
      expect(sorted_people[9].name4).to eq('M')
    end
  end
end
