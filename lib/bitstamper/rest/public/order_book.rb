module Bitstamper
  module Rest
    module Public
      module OrderBook
      
        def order_book(currency_pair = "btcusd")
          response    =   get(path_with_currency_pair("/v2/order_book", currency_pair))
          ::Bitstamper::Models::OrderBook.new(response) if response
        end
      
      end
    end
  end
end
