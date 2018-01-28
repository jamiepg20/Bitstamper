module Bitstamper
  module Rest
    module Private
      module Balances
      
        def balance(currency_pair: nil)
          check_credentials!
        
          path        =   path_with_currency_pair("/v2/balance", currency_pair)
          response    =   post(path)
      
          ::Bitstamper::Models::Balance.parse(response) if response
        end
      
      end
    end
  end
end
