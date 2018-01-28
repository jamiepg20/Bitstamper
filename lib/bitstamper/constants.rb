module Bitstamper
  module Constants
    
    BUY_ORDER           =   0
    SELL_ORDER          =   1
    
    AVAILABLE_CRYPTOS   =   [
      "btc",
      "eth",
      "xrp",
      "bch",
      "ltc"
    ]
    
    TRADEABLE           =   AVAILABLE_CRYPTOS | ["eur", "usd"]
    
    TIME_IN_SECONDS     =   {
      day: 86400,
      hour: 3600
    }
    
    ERRORS              =   {
      matches: {
        invalid_permissions: "No permission found",
        invalid_order:       "Order not found",
      },
      
      responses: {
        invalid_permissions: "Not allowed to perform this action - check your API key credentials.",
      }
    }
    
  end
end
