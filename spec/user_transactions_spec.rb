require 'spec_helper'

describe Bitstamper::Rest::Client do
  describe :user_transactions, vcr: {cassette_name: 'bitstamp/transactions/user'} do
    before { setup_bitstamper }
    
    let(:client) { Bitstamper::Rest::Client.new }
    let(:user_transactions) { client.user_transactions }
    let(:user_transaction) { user_transactions.first }
    
    it { expect(user_transactions).to be_a_kind_of(Array) }
    it { expect(user_transactions.count).to eq 20 }
    
    expectations = {
      id:               "49313217",
      fee:              0.0,
      btc_usd:          0.0,
      datetime:         DateTime.new(2018, 01, 24, 13, 15, 8, 0),
      usd:              0.0,
      btc:              0.0,
      type:             0,
      eur:              500.0,
      transaction_type: :deposit
    }
    
    expectations.each do |key, value|
      it { expect(user_transaction.send(key)).to eq value }
    end
  end
end
