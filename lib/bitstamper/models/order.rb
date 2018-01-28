module Bitstamper
  module Models
    class Order < Base
      attr_accessor :id, :currency_pair, :type, :order_type, :price, :amount, :datetime
      attr_accessor :event, :error, :message
      
      BUY   =   0
      SELL  =   1
      
      MAPPING             =   {
        "id"              =>   :string,
        "currency_pair"   =>   :string,
        "type"            =>   :integer,
        "price"           =>   :float,
        "amount"          =>   :float,
        "event"           =>   :string
      }
      
      def initialize(hash)
        hash["type"]      =     hash["order_type"] if hash.fetch("type", nil).to_s.empty? && hash.has_key?("order_type")
        
        hash.each do |key, value|
          type            =     ::Bitstamper::Models::Order::MAPPING.fetch(key, nil)
          value           =     value && type ? ::Bitstamper::Utilities::convert_value(value, type) : value
          self.send("#{key}=", value) if self.respond_to?(key)
        end
        
        datetime          =     hash.fetch("datetime", nil)&.to_s
        
        if !datetime.to_s.empty? && datetime.include?("-")
          self.datetime   =     ::Bitstamper::Utilities::convert_value(datetime, :datetime)
        elsif !datetime.to_s.empty? && ::Bitstamper::Utilities.numeric?(datetime)
          self.datetime   =     ::Bitstamper::Utilities::convert_value(datetime, :time)
        end
        
        self.order_type   =     case self.type
          when ::Bitstamper::Models::Order::BUY  then :buy
          when ::Bitstamper::Models::Order::SELL then :sell
        end
      end
      
      def self.parse(data)
        data&.collect { |item| ::Bitstamper::Models::Order.new(item) }
      end
      
    end
  end
end
