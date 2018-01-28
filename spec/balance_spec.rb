require 'spec_helper'

describe Bitstamper::Rest::Client do
  describe :balance, vcr: {cassette_name: 'bitstamp/balance'} do
    let(:client) { Bitstamper::Rest::Client.new }
    
    context "configured" do
      before { setup_bitstamper }
      let(:balances) { client.balance }
      
      it { expect(balances).to be_a_kind_of(Array) }
      
      expectations = {
        available:  0.0,
        balance:    0.0,
        reserved:   0.0,
        fees:       {btc: 0.06, eur: 0.06, usd: 0.06},
        currency:   "BCH"
      }
      
      expectations.each do |key, value|
        it { expect(balances.first.send(key)).to eq value }
      end
    end
    
    it "is not configured" do
      expect { client.check_credentials! }.to raise_error Bitstamper::Errors::MissingConfigError
    end
    
  end
end
