module Bitstamper
  module Models
    class Withdrawal < Base
      attr_accessor :id, :currency, :amount, :datetime
      attr_accessor :type, :status
      attr_accessor :address, :transaction_id
      
      TYPES               =   {
        0   =>  :sepa,
        1   =>  :bitcoin,
        2   =>  :wire,
        14  =>  :xrp,
        15  =>  :ltc,
        16  =>  :eth
      }
      
      STATUS              =   {
        0   =>  :open,
        1   =>  :in_process,
        2   =>  :finished,
        3   =>  :cancelled,
        4   =>  :failed
      }
      
      MAPPING             =   {
        "id"              =>  :string,
        "currency"        =>  :string,
        "amount"          =>  :float,
        "datetime"        =>  :datetime,
        "type"            =>  :integer,
        "status"          =>  :integer,
        "address"         =>  :string,
        "transaction_id"  =>  :string
      }
      
      def initialize(hash)
        hash.each do |key, value|
          type            =     ::Bitstamper::Models::Withdrawal::MAPPING.fetch(key, nil)
          value           =     value && type ? ::Bitstamper::Utilities::convert_value(value, type) : value
          self.send("#{key}=", value) if self.respond_to?(key)
        end
        
        self.type         =   TYPES[self.type]
        self.status       =   STATUS[self.status]
      end
      
      def self.parse(data)
        data&.collect { |item| ::Bitstamper::Models::Withdrawal.new(item) }
      end
      
    end
  end
end
