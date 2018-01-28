module Bitstamper
  module Models
    class OrderBook
      attr_accessor :timestamp, :bids, :asks
      
      def initialize(hash)
        self.bids   =   []
        self.asks   =   []
        
        self.timestamp  =  ::Bitstamper::Utilities.epoch_to_time(hash.fetch("timestamp", nil)) if hash.has_key?("timestamp") && !hash.fetch("timestamp", nil).to_s.empty?
        
        process(hash)
      end
      
      def process(hash)
        [:bids, :asks].each do |type|
          hash.fetch(type.to_s, []).each do |item|
            price     =   item&.first&.to_f
            quantity  =   item&.last&.to_f
            value     =   !price.nil? && !quantity.nil? ? price * quantity : nil
            self.send(type).send(:<<, {price: price, quantity: quantity, value: value})
          end
        end
      end
      
    end
  end
end
