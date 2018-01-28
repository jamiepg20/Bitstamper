module Bitstamper
  module Models
    class UserTransaction < Base
      attr_accessor :id, :order_id, :type, :transaction_type, :datetime, :fee
      attr_accessor :usd, :eur
      attr_accessor :btc, :btc_usd, :btc_eur
      attr_accessor :eth, :eth_btc, :eth_usd, :eth_eur
      attr_accessor :ltc, :xrp, :bch
      
      TYPES = {
        0   =>  :deposit,
        1   =>  :withdrawal,
        2   =>  :market_trade,
        14  =>  :sub_account_transfer 
      }
      
      MAPPING             =   {
        "id"              =>   :string,
        "order_id"        =>   :string,
        "type"            =>   :integer,
        "datetime"        =>   :datetime,
        "fee"             =>   :float,
        "usd"             =>   :float,
        "eur"             =>   :float,
        "btc"             =>   :float,
        "btc_usd"         =>   :float,
        "btc_eur"         =>   :float,
        "eth"             =>   :float,
        "eth_btc"         =>   :float,
        "eth_usd"         =>   :float,
        "eth_eur"         =>   :float,
        "ltc"             =>   :float,
        "xrp"             =>   :float,
        "bch"             =>   :float,
      }
      
      def initialize(hash)
        hash.each do |key, value|
          type            =     ::Bitstamper::Models::UserTransaction::MAPPING.fetch(key, nil)
          value           =     value && type ? ::Bitstamper::Utilities::convert_value(value, type) : value
          self.send("#{key}=", value) if self.respond_to?(key)
        end
        
        self.id           =     hash.fetch("id", hash.fetch("tid", nil))&.to_s
        
        self.transaction_type = TYPES[self.type]
      end
      
      def self.parse(data)
        data&.collect { |item| ::Bitstamper::Models::UserTransaction.new(item) }
      end
      
    end
  end
end
