require 'spec_helper'

describe Bitstamper::Rest::Client do

  describe :eur_usd_rate, vcr: {cassette_name: 'bitstamp/eur_usd_rate'} do
    let(:client) { Bitstamper::Rest::Client.new }
    let(:result) { client.eur_usd_rate }
    
    it { expect(result).to be_a_kind_of Hash }
        
    expectations = {
      buy:  1.2485,
      sell: 1.2384
    }
    
    expectations.each do |key, value|
      it { expect(result.fetch(key, nil)).to eq value }
    end
  end

end
