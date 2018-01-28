require 'spec_helper'

describe Bitstamper::Configuration do
  
  describe :check_credentials! do
    let(:client) { Bitstamper::Rest::Client.new }
    subject { client }
    
    it 'is not properly configured' do
      expect { client.check_credentials! }.to raise_error ::Bitstamper::Errors::MissingConfigError
    end
    
    describe 'setting up proper configuration' do
      before {
        Bitstamper.configure do |config|
          config.key        =   'test'
          config.secret     =   'test'
          config.client_id  =   'test'
        end
      }
      
      it 'is properly configured' do
        expect { client.check_credentials! }.not_to raise_error
      end
    end
  end

end
