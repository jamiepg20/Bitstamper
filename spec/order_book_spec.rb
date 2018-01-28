require 'spec_helper'

describe Bitstamper::Rest::Client do
  describe :order_book, vcr: {cassette_name: 'bitstamp/order_book'} do
    let(:client) { Bitstamper::Rest::Client.new }
    let(:order_book) { client.order_book }
    
    expectations = {
      bids: {
        price:    11691.0,
        quantity: 0.01710696,
        value:    199.99746936
      },
      
      asks: {
        price:    11699.99,
        quantity: 0.01017035,
        value:    118.99299329649999
      }
    }
    
    it { expect(order_book).to be_a_kind_of(::Bitstamper::Models::OrderBook) }
    
    [:bids, :asks].each do |type|
      expectations[type].each do |key, value|
        it { expect(order_book.send(type).first.fetch(key, nil)).to eq value }
      end
    end

  end
end
