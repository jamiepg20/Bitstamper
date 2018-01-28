module Bitstamper
  module Rest
    module Public
      module Currencies
        
        def eur_usd_rate
          response = get("/eur_usd")
          {buy: response&.fetch("buy", nil)&.to_f, sell: response&.fetch("sell", nil)&.to_f}
        end
      
      end
    end
  end
end
