module Bitstamper
  module Models
    class Deposit < Base
      attr_accessor :address, :amount, :confirmations
      
      MAPPING             =   {
        "address"         =>   :string,
        "amount"          =>   :float,
        "confirmations"   =>   :integer,
      }
      
      def initialize(hash)
        hash.each do |key, value|
          type            =     ::Bitstamper::Models::Deposit::MAPPING.fetch(key, nil)
          value           =     value && type ? ::Bitstamper::Utilities::convert_value(value, type) : value
          self.send("#{key}=", value) if self.respond_to?(key)
        end
      end
      
      def self.parse(data)
        data&.collect { |item| ::Bitstamper::Models::Deposit.new(item) }
      end
      
    end
  end
end
