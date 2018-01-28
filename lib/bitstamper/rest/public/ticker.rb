module Bitstamper
  module Rest
    module Public
      module Ticker
      
        def daily_ticker(currency_pair: "btcusd", options: {})
          ticker(currency_pair: currency_pair, interval: :daily, options: options)
        end
      
        def hourly_ticker(currency_pair: "btcusd", options: {})
          ticker(currency_pair: currency_pair, interval: :hourly, options: options)
        end
      
        def ticker(currency_pair: "btcusd", interval: :daily, options: {})
          path        =   case interval.to_sym
            when :daily
              !currency_pair.to_s.empty? ? "/v2/ticker/#{::Bitstamper::Utilities.fix_currency_pair(currency_pair)}" : "/ticker"
            when :hourly
              !currency_pair.to_s.empty? ? "/v2/ticker_hour/#{::Bitstamper::Utilities.fix_currency_pair(currency_pair)}" : "/ticker_hour"
          end

          response    =   get(path, options: options)
        
          ::Bitstamper::Models::Ticker.new(response.merge("currency_pair" => currency_pair)) if response
        end
      
      end
    end
  end
end
