module Bitstamper
  module Rest
    module Public
      module TradingPairs
        
        def trading_pairs
          response    =   get("/v2/trading-pairs-info")
          ::Bitstamper::Models::TradingPair.parse(response) if response
        end
      
      end
    end
  end
end
