module Bitstamper
  module Models
    class Ticker < Base
      attr_accessor :last, :high, :low, :volume, :bid, :ask, :timestamp, :vwap, :open, :currency_pair
      
      MAPPING             =   {
        "high"          =>    :float,
        "last"          =>    :float,
        "timestamp"     =>    :time,
        "bid"           =>    :float,
        "vwap"          =>    :float,
        "volume"        =>    :float,
        "low"           =>    :float,
        "ask"           =>    :float,
        "open"          =>    :float,
        "currency_pair" =>    :string,
      }
    
      def initialize(hash)
        hash.each do |key, value|
          type            =     ::Bitstamper::Models::Ticker::MAPPING.fetch(key, nil)
          value           =     value && type ? ::Bitstamper::Utilities::convert_value(value, type) : value
          self.send("#{key}=", value) if self.respond_to?(key)
        end
      end
      
      def self.parse(data)
        data&.collect { |item| ::Bitstamper::Models::Ticker.new(item) }
      end

    end
  end
end
