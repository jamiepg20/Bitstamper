require 'spec_helper'

describe Bitstamper::Rest::Client do

  describe :trading_pairs, vcr: {cassette_name: 'bitstamp/trading_pairs'} do
    let(:client) { Bitstamper::Rest::Client.new }
    let(:trading_pairs) { client.trading_pairs }
    let(:trading_pair) { trading_pairs.first }
    
    it { expect(trading_pairs).to be_a_kind_of Array }
    it { expect(trading_pairs.count).to eq 15 }
        
    expectations = {
      name:             "LTC/USD",
      url_symbol:       "ltcusd",
      description:      "Litecoin / U.S. dollar",
      trading:          "Enabled",
      base_decimals:    8,
      counter_decimals: 2,
      minimum_order:    "5.0 USD"
    }
    
    expectations.each do |key, value|
      it { expect(trading_pair.send(key)).to eq value }
    end
  end

end
