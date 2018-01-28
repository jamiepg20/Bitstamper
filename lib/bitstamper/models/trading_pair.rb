module Bitstamper
  module Models
    class TradingPair < Base
      attr_accessor :name, :url_symbol, :description
      attr_accessor :base_decimals, :counter_decimals, :minimum_order, :trading
      
      MAPPING             =   {
        "name"              =>   :string,
        "url_symbol"        =>   :string,
        "description"       =>   :string,
        "base_decimals"     =>   :integer,
        "counter_decimals"  =>   :integer,
        "minimum_order"     =>   :string,
        "trading"           =>   :string,
      }
      
      def initialize(hash)
        hash.each do |key, value|
          type            =     ::Bitstamper::Models::TradingPair::MAPPING.fetch(key, nil)
          value           =     value && type ? ::Bitstamper::Utilities::convert_value(value, type) : value
          self.send("#{key}=", value) if self.respond_to?(key)
        end
      end
      
      def enabled?
        self.trading.downcase.strip.eql?("enabled")
      end
      
      def self.parse(data)
        data&.collect { |item| ::Bitstamper::Models::TradingPair.new(item) }
      end
      
    end
  end
end
