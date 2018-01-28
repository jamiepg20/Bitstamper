require 'spec_helper'

describe "Placing sell orders" do
  let(:client) { Bitstamper::Rest::Client.new }
  
  describe :buy do
    context "permissions" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/sell/permissions/invalid'} do
        before { setup_bitstamper(:partial) }
      
        it "has invalid API permissions" do
          expect { client.sell(currency_pair: "eurusd", amount: 0.01, price: 10000.0) }.to raise_error Bitstamper::Errors::InvalidPermissionsError
        end
      end
  
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/sell/permissions/valid'} do
        before { setup_bitstamper }
    
        it "has valid API permissions" do
          expect { client.sell(currency_pair: "eurusd", amount: 0.01, price: 10000.0) }.not_to raise_error
        end
      end
    end
    
    context "balance" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/sell/balance/invalid'} do
        before { setup_bitstamper }
      
        it "tries to sell using insufficient balance" do
          expect { client.sell(currency_pair: "ethusd", amount: 0.01, price: 2000.0) }.to raise_error Bitstamper::Errors::InvalidOrderError
        end
      end
  
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/sell/balance/valid'} do
        before { setup_bitstamper }
    
        it "tries to sell using sufficient balance" do
          expect { client.sell(currency_pair: "eurusd", amount: 0.01, price: 10000.0) }.not_to raise_error
        end
      end
    end
    
    context "order amount" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/sell/amount/invalid'} do
        before { setup_bitstamper }
      
        it "tries to buy using an invalid order amount" do
          expect { client.sell(currency_pair: "eurusd", amount: 0.000000000000000001, price: 5000.0) }.to raise_error Bitstamper::Errors::InvalidAmountError
        end
      end
  
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/sell/amount/valid'} do
        before { setup_bitstamper }
    
        it "tries to buy using a valid order amount" do
          expect { client.sell(currency_pair: "eurusd", amount: 0.01, price: 10000.0) }.not_to raise_error
        end
      end
    end
    
    context "order size" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/sell/size/invalid'} do
        before { setup_bitstamper }
      
        it "tries to buy using an invalid order size" do
          expect { client.sell(currency_pair: "eurusd", amount: 0.0001, price: 10000.0) }.to raise_error Bitstamper::Errors::InvalidOrderError
        end
      end
  
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/sell/size/valid'} do
        before { setup_bitstamper }
    
        it "tries to buy using a valid order size" do
          expect { client.sell(currency_pair: "eurusd", amount: 0.01, price: 10000.0) }.not_to raise_error
        end
      end
    end
  end
  
end
