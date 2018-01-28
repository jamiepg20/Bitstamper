module Bitstamper
  module Models
    class Transaction < Base
      attr_accessor :id, :type, :transaction_type, :date, :price, :amount
      
      TYPES               =   {
        0 => :buy,
        1 => :sell
      }
      
      MAPPING             =   {
        "id"              =>   :string,
        "type"            =>   :integer,
        "date"            =>   :time,
        "price"           =>   :float,
        "amount"          =>   :float,
      }
      
      def initialize(hash)
        hash.each do |key, value|
          type            =     ::Bitstamper::Models::Transaction::MAPPING.fetch(key, nil)
          value           =     value && type ? ::Bitstamper::Utilities::convert_value(value, type) : value
          self.send("#{key}=", value) if self.respond_to?(key)
        end
        
        self.id           =     hash.fetch("id", hash.fetch("tid", nil))&.to_s
        
        self.transaction_type = TYPES[self.type]
      end
      
      def self.parse(data)
        data&.collect { |item| ::Bitstamper::Models::Transaction.new(item) }
      end
      
    end
  end
end
