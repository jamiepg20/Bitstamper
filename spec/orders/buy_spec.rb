require 'spec_helper'

describe "Placing buy orders" do
  let(:client) { Bitstamper::Rest::Client.new }
  
  describe :buy do
    context "permissions" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/buy/permissions/invalid'} do
        before { setup_bitstamper(:partial) }
      
        it "has invalid API permissions" do
          expect { client.buy(currency_pair: "etheur", amount: 0.01, price: 501.0) }.to raise_error Bitstamper::Errors::InvalidPermissionsError
        end
      end
  
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/buy/permissions/valid'} do
        before { setup_bitstamper }
    
        it "has valid API permissions" do
          expect { client.buy(currency_pair: "etheur", amount: 0.01, price: 501.0) }.not_to raise_error
        end
      end
    end
    
    context "balance" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/buy/balance/invalid'} do
        before { setup_bitstamper }
      
        it "tries to buy using insufficient balance" do
          expect { client.buy(currency_pair: "ethusd", amount: 0.01, price: 501.0) }.to raise_error Bitstamper::Errors::InvalidOrderError
        end
      end
  
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/buy/balance/valid'} do
        before { setup_bitstamper }
    
        it "tries to buy using sufficient balance" do
          expect { client.buy(currency_pair: "etheur", amount: 0.01, price: 501.0) }.not_to raise_error
        end
      end
    end
    
    context "order amount" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/buy/amount/invalid'} do
        before { setup_bitstamper }
      
        it "tries to buy using an invalid order amount" do
          expect { client.buy(currency_pair: "etheur", amount: 0.0000000001, price: 501.0) }.to raise_error Bitstamper::Errors::InvalidAmountError
        end
      end
  
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/buy/amount/valid'} do
        before { setup_bitstamper }
    
        it "tries to buy using a valid order amount" do
          expect { client.buy(currency_pair: "etheur", amount: 0.01, price: 501.0) }.not_to raise_error
        end
      end
    end
    
    context "order size" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/buy/size/invalid'} do
        before { setup_bitstamper }
      
        it "tries to buy using an invalid order size" do
          expect { client.buy(currency_pair: "etheur", amount: 0.01, price: 1) }.to raise_error Bitstamper::Errors::InvalidOrderError
        end
      end
  
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/buy/size/valid'} do
        before { setup_bitstamper }
    
        it "tries to buy using a valid order size" do
          expect { client.buy(currency_pair: "etheur", amount: 0.01, price: 501.0) }.not_to raise_error
        end
      end
    end
  end
  
end
