module Bitstamper
  module Rest
    module Private
      module Withdrawals
        
        def withdraw(currency, address:, amount:, instant: nil)
          check_credentials!
  
          currency    =   currency.to_s.downcase
          
          if !::Bitstamper::Constants::AVAILABLE_CRYPTOS.include?(currency)
            raise ::Bitstamper::Errors::InvalidCurrencyError.new("#{currency} is not a tradeable crypto currency on Bitstamp.")
          end
          
          path        =   currency.eql?("btc") ? "/bitcoin_withdrawal" : "/v2/#{currency}_withdrawal"
          
          data        =   {
            address:  address,
            amount:   amount,
          }
          
          data[:instant] = 1 if (currency.eql?("btc") && (instant.eql?(true) || instant.eql?(1)))
          
          response    =   parse(post(path, data: data))
          response    =   response.is_a?(String) ? {"id" => response} : response
  
          return response
        end
        
        def withdrawal_requests(interval: ::Bitstamper::Constants::TIME_IN_SECONDS[:day])
          check_credentials!
          
          response    =   post("/v2/withdrawal-requests", data: {timedelta: interval})
          
          Bitstamper::Models::Withdrawal.parse(response) if response
        end
        
        def bank_withdrawal_status(id)
          check_credentials!
          
          response    =   post("/v2/withdrawal/status", data: {id: id})
        end
        
        def cancel_bank_withdrawal(id)
          check_credentials!
          
          response    =   post("/v2/withdrawal/cancel", data: {id: id})
        end
      
      end
    end
  end
end
