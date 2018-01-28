require 'spec_helper'

describe "Cancelling all orders" do
  let(:client) { Bitstamper::Rest::Client.new }
  
  describe :cancel_all_orders do
    context "permissions" do
      describe :invalid, vcr: {cassette_name: 'bitstamp/orders/cancel_all/invalid'} do
        before { setup_bitstamper(:partial) }
      
        it "has invalid API permissions" do
          expect { client.cancel_all_orders! }.to raise_error Bitstamper::Errors::InvalidPermissionsError
        end
      end
  
      describe :valid, vcr: {cassette_name: 'bitstamp/orders/cancel_all/valid'} do
        before { setup_bitstamper }
    
        it "has valid API permissions" do
          expect { client.cancel_all_orders! }.not_to raise_error
          expect(client.cancel_all_orders!).to eq true
        end
      end
    end
  end

end
