require 'spec_helper'

describe "Cancelling specific order" do
  let(:client) { Bitstamper::Rest::Client.new }
    
  describe :cancel_order do
    context "permissions" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/cancel/permissions/invalid'} do
        before { setup_bitstamper(:partial) }
        let(:order_id) { "851176948" }
    
        it "has invalid API permissions" do
          expect { client.cancel_order!(order_id) }.to raise_error Bitstamper::Errors::InvalidPermissionsError
        end
      end
      
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/cancel/permissions/valid'} do
        before { setup_bitstamper }
        let(:order_id) { "851176948" }
    
        it "has valid API permissions" do
          expect { client.cancel_order!(order_id) }.not_to raise_error
        end
      end
    end
    
    context "validity" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/cancel/validity/invalid'} do
        before { setup_bitstamper }
        let(:order_id) { "1111111111111111" }
  
        it "is using an invalid order id" do
          expect { client.check_credentials! }.not_to raise_error
          expect { client.cancel_order!(order_id) }.to raise_error Bitstamper::Errors::InvalidOrderError
        end
      end
    
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/cancel/validity/valid'} do
        before { setup_bitstamper }
        let(:order_id) { "851176948" }
        let(:order) { client.cancel_order!(order_id) }
  
        it "is using a valid order id" do
          expect { client.check_credentials! }.not_to raise_error
          expect { order }.not_to raise_error
        
          expectations = {
            id:               order_id,
            price:            501.0,
            amount:           0.01,
            type:             0,
          }
  
          expect(order).to be_a_kind_of(::Bitstamper::Models::Order)
  
          expectations.each do |key, value|
            expect(order.send(key)).to eq value
          end
        end
      end
    end
    
  end
  
end
