require 'spec_helper'

require 'active_support'
require 'messente-rails'
RSpec.describe Messente, type: :model do
  before(:example) do
    # Simulate initializer for class methods
    MessenteRails::Configuration.username = 'username'
    MessenteRails::Configuration.password = 'password'
  end

  def fake_success(uri, body)
    stub_request(:post, uri).
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => body, :headers => {})
  end

  let(:messente) { described_class.new('username', 'password') }

  describe '#new' do
    it { is_expected.to be_a Messente }
  end

  describe 'send_sms' do
    it { expect{ messente.send_sms}.to raise_error(ArgumentError) }

    context 'with valid params' do
      before(:example) do
        uri = "http://api2.messente.com/send_sms/?password=password&text=test&to=%2B372055123456&username=username"
        @expected = 'OK hnoac48nta938ynvas039n04972'
        fake_success(uri, @expected)
        @params = { to: '+372055123456', text: 'test' }
      end

      it { expect(messente.send_sms(@params)).to eq(@expected) }
      it { expect(described_class.send_sms(@params)).to eq(@expected) }
    end
  end

  describe 'get_dlr_response' do
    it { expect{ messente.get_dlr_response }.to raise_error(ArgumentError) }

    context 'with valid params' do
      before(:example) do
        uri = "http://api2.messente.com/get_dlr_response/?password=password&sms_unique_id=1&username=username"
        @expected = 'OK SENT'
        fake_success(uri, @expected)
        @params = { sms_unique_id: 1 }
      end

      it { expect(messente.get_dlr_response(@params)).to eq(@expected) }
      it { expect(described_class.get_dlr_response(@params)).to eq(@expected) }
    end
  end

  describe 'get_balance' do
    before(:example) do
      uri = "http://api2.messente.com/get_balance/?password=password&username=username"
      @expected = 'OK 707.54'
      fake_success(uri, @expected)
    end

    it { expect(messente.get_balance).to eq(@expected) }
    it { expect(described_class.get_balance).to eq(@expected) }
  end

  describe 'prices' do
    it { expect{ messente.prices }.to raise_error(ArgumentError) }

    context 'with valid attributes' do
      before(:example) do
        uri = "http://api2.messente.com/prices/?country=EE&password=password&username=username"
        @expected = {"country":"EE","name":"Estonia","prefix":"372","networks":[{"mccmnc":"24803","name":"Tele2","price":"0.06000"}]}.to_json
        fake_success(uri, @expected)
        @params = { country: 'EE' }
      end

      it { expect(messente.prices(@params)).to eq(@expected) }
      it { expect(described_class.prices(@params)).to eq(@expected) }
    end
  end

  describe 'pricelist' do
    before(:example) do
      uri = "http://api2.messente.com/pricelist/?password=password&username=username"
      @expected = "Country,Code,MCCMNC,Network,Price\nCanada,CA,302270,EastLink,0.0062"
      fake_success(uri, @expected)
    end

    it { expect(messente.pricelist).to eq(@expected) }
    it { expect(described_class.pricelist).to eq(@expected) }
  end
end

