module Bitstamper
  module Rest
    module Private
      module Deposits
      
        def btc_deposit_address
          deposit_address("btc")
        end
        
        def eth_deposit_address
          deposit_address("eth")
        end
        
        def xrp_deposit_address
          deposit_address("xrp")
        end
        
        def bch_deposit_address
          deposit_address("bch")
        end
        
        def ltc_deposit_address
          deposit_address("ltc")
        end

        def deposit_address(currency)
          check_credentials!
  
          currency    =   currency.to_s.downcase
          
          if !::Bitstamper::Constants::AVAILABLE_CRYPTOS.include?(currency)
            raise ::Bitstamper::Errors::InvalidCurrencyError.new("#{currency} is not a tradeable crypto currency on Bitstamp.")
          end
          
          path        =   currency.eql?("btc") ? "/bitcoin_deposit_address" : "/v2/#{currency}_address"
          response    =   post(path)
          response    =   response.is_a?(String) ? {"address" => response} : response
  
          return response
        end

        def unconfirmed_bitcoins
          check_credentials!
          response    =   post("/unconfirmed_btc")
          Bitstamper::Models::Deposit.parse(response) if response
        end
      
      end
    end
  end
end
