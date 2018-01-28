module Bitstamper
  module Rest
    module Private
      module Orders
            
        def open_orders(currency_pair = nil)
          path      =   !currency_pair.to_s.empty? ? "/v2/open_orders/#{::Bitstamper::Utilities.fix_currency_pair(currency_pair)}" : "/v2/open_orders/all"
          response  =   post(path)
          Bitstamper::Models::Order.parse(response) if response
        end
      
        def find_open_order(order_id)
          open_orders.select { |order| order.id == order_id }&.first
        end
    
        # https://www.bitstamp.net/api/#buy-order
        def buy(currency_pair: "btcusd", amount:, price:, limit_price: nil, daily_order: nil)
          create_order(
            currency_pair: currency_pair,
            direction:     Bitstamper::Constants::BUY_ORDER,
            amount:        amount,
            price:         price,
            limit_price:   limit_price,
            daily_order:   daily_order
          )
        end
    
        # https://www.bitstamp.net/api/#sell-order
        def sell(currency_pair: "btcusd", amount:, price:, limit_price: nil, daily_order: nil)
          create_order(
            currency_pair: currency_pair,
            direction:     Bitstamper::Constants::SELL_ORDER,
            amount:        amount,
            price:         price,
            limit_price:   limit_price,
            daily_order:   daily_order
          )
        end
        
        # Request parameters
        # [AUTH]
        # amount - Amount.
        # price - Price.
        # limit_price - If the order gets executed, a new sell order will be placed, with "limit_price" as its price.
        # daily_order - (Optional): Opens buy limit order which will be canceled at 0:00 UTC unless it already has been executed. Possible value: True
        def create_order(currency_pair: "btcusd", direction: Bitstamper::Constants::BUY_ORDER, amount:, price:, limit_price: nil, daily_order: nil)
          currency_pair         =   ::Bitstamper::Utilities.fix_currency_pair(currency_pair)
          direction             =   fix_order_direction(direction)
          
          path                  =   case direction
            when Bitstamper::Constants::BUY_ORDER
              "/v2/buy/#{currency_pair}"
            when Bitstamper::Constants::SELL_ORDER
              "/v2/sell/#{currency_pair}"
          end
          
          data                  =   {
            amount: amount,
            price:  price
          }
          
          data[:limit_price]    =   limit_price if !limit_price.nil?
          data[:daily_order]    =   true if daily_order == true
          
          response              =   parse(post(path, data: data))
          
          Bitstamper::Models::Order.new(response.merge("currency_pair" => currency_pair)) if response
        end
        
        def fix_order_direction(direction)
          if direction.is_a?(Symbol)
            direction           =   case direction
              when :buy
                Bitstamper::Constants::BUY_ORDER
              when :sell
                Bitstamper::Constants::SELL_ORDER
            end
          end
          
          return direction
        end
      
        def order_status(order_id)
          response        =   post("/order_status", data: {id: order_id})
          status          =   response&.fetch("status", nil)
          transactions    =   Bitstamper::Models::UserTransaction.parse(response&.fetch("transactions", []))
          
          return {status: status, transactions: transactions}
        end

        def cancel_all_orders!
          parse(post('/cancel_all_orders'))
        end
  
        def cancel_order!(order_id)
          response        =   parse(post('/v2/cancel_order', data: {id: order_id}))
          Bitstamper::Models::Order.new(response) if response
        end
    
      end
    end
  end
end
