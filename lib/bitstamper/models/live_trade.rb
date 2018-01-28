module Bitstamper
  module Models
    class LiveTrade < Base
      attr_accessor :id, :buy_order_id, :sell_order_id
      attr_accessor :amount, :amount_str, :price, :price_str
      attr_accessor :epoch, :timestamp
      attr_accessor :type
      attr_accessor :product
      
      TYPES             =   {
        0 => :buy,
        1 => :sell
      }
      
      MAPPING           =   {
        id:                             :string,
        buy_order_id:                   :string,
        sell_order_id:                  :string,
        amount:                         :float,
        amount_str:                     :string,
        price:                          :float,
        price_str:                      :string,
        epoch:                          :integer,
        timestamp:                      :time,
        type:                           :integer,
        product:                        :string,
      }
      
      def initialize(hash)
        hash.each do |key, value|
          type      =     ::Bitstamper::Models::LiveTrade::MAPPING.fetch(key, nil)
          value     =     value && type ? ::Bitstamper::Utilities::convert_value(value, type) : value
          self.send("#{key}=", value) if self.respond_to?(key)
        end
        
        self.type   =   TYPES[self.type]
      end
      
    end
  end
end
