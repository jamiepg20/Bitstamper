require 'spec_helper'

describe "Listing all open orders" do
  let(:client) { Bitstamper::Rest::Client.new }
  
  describe :open_orders, vcr: {cassette_name: 'bitstamp/orders/open_orders'} do
    before { setup_bitstamper }
    
    let(:orders) { client.open_orders }
    let(:order) { orders.first }
    
    it { expect(orders).to be_a_kind_of(Array) }
    it { expect(orders.count).to eq 1 }
    
    expectations = {
      id:               "837983329",
      currency_pair:    "ETH/EUR",
      price:            781.82,
      amount:           1.27588188,
      datetime:         DateTime.new(2018, 01, 26, 10, 49, 7, 0),
      type:             0,
      order_type:       :buy,
    }
    
    expectations.each do |key, value|
      it { expect(order.send(key)).to eq value }
    end
  end
    
end
