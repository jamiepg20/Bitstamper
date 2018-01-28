require 'spec_helper'

describe "Deposits" do
  before { setup_bitstamper }
  let(:client) { Bitstamper::Rest::Client.new }
  
  ::Bitstamper::Constants::AVAILABLE_CRYPTOS.each do |crypto|
    deposit_address_options = {}
    # Disable casettes due to privacy concerns for the deposit address functions
    #deposit_address_options = {vcr: {cassette_name: "bitstamp/deposits/#{crypto}_deposit_address"}}
    
    describe "#{crypto}_deposit_address", deposit_address_options do
      if deposit_address_options.empty?
        before do
          VCR.turn_off!(ignore_cassettes: true)
          WebMock.allow_net_connect!
        end

        after do
          VCR.turn_on!
        end
      end
      
      let(:address) { client.deposit_address(crypto) }
    
      it "should have a valid address" do
        expect(address).to be_a_kind_of(Hash)
        expect(address.fetch("address", nil)).not_to be_nil
        expect(address.fetch("destination_tag", nil)).not_to be_nil if crypto.eql?("xrp")
      end

    end
  end
  
  describe :unconfirmed_bitcoins, vcr: {cassette_name: 'bitstamp/deposits/unconfirmed_bitcoins'} do
    let(:bitcoins) { client.unconfirmed_bitcoins }
    
    it { expect(bitcoins).to be_a_kind_of(Array) }
    it { expect(bitcoins.count).to eq 0 }
  end
end
