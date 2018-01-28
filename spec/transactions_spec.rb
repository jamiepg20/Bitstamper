require 'spec_helper'

describe Bitstamper::Rest::Client do

  describe :transactions, vcr: {cassette_name: 'bitstamp/transactions'} do
    let(:client) { Bitstamper::Rest::Client.new }
    let(:transactions) { client.transactions }
    let(:transaction) { transactions.first }
    
    it { expect(transactions).to be_a_kind_of Array }
    it { expect(transactions.count).to eq 2191 }
    
    expectations = {
      id:               "49957720",
      price:            11699.9,
      amount:           0.01461107,
      date:             Time.new(2018, 01, 28, 11, 12, 4, 0),
      type:             0,
      transaction_type: :buy
    }
    
    expectations.each do |key, value|
      it { expect(transaction.send(key)).to eq value }
    end
  end

end
