require 'spec_helper'

describe Bitstamper::Rest::Client do
  describe :ticker, vcr: {cassette_name: 'bitstamp/ticker'} do
    let(:client) { Bitstamper::Rest::Client.new }
    let(:ticker) { client.ticker }
    
    expectations = {
      high:       11989.15,
      last:       11847.99,
      timestamp:  Time.new(2018, 01, 28, 10, 34, 52, 0),
      bid:        11801.09,
      vwap:       11499.77,
      volume:     11185.88675316,
      low:        10815.84,
      ask:        11829.86,
      open:       11446.54
    }
    
    it { expect(ticker).to be_a_kind_of(::Bitstamper::Models::Ticker) }
  
    expectations.each do |key, value|
      it { expect(ticker.send(key)).to eq value }
    end

  end
end
