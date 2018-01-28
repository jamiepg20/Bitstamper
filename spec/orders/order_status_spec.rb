require 'spec_helper'

describe "Checking status for a specific order" do
  let(:client) { Bitstamper::Rest::Client.new }
  
  describe :order_status, vcr: {cassette_name: 'bitstamp/orders/order_status'} do
    before { setup_bitstamper }
    
    let(:order_id) { "783645067" }
    let(:result) { client.order_status(order_id) }
    let(:transactions) { result.fetch(:transactions, []) }
    let(:transaction) { transactions.first }
    
    it { expect(transactions).to be_a_kind_of(Array) }
    it { expect(transactions.count).to eq 6 }
    
    expectations = {
      id:               "47342423",
      fee:              0.29,
      datetime:         DateTime.new(2018, 01, 17, 21, 49, 54, 0),
      btc:              0.012306,
      type:             2,
      eur:              114.50720694,
      transaction_type: :market_trade
    }
    
    it { expect(transaction).to be_a_kind_of(::Bitstamper::Models::UserTransaction) }
    
    expectations.each do |key, value|
      it { expect(transaction.send(key)).to eq value }
    end
  end
  
end
