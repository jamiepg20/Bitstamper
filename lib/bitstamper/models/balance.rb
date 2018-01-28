module Bitstamper
  module Models
    class Balance
      attr_accessor :currency, :available, :balance, :reserved, :fees
      
      def initialize(hash)
        hash.each do |key, value|
          self.send("#{key}=", value) if self.respond_to?(key)
        end
      end
      
      def self.parse(hash)
        parsed                  =   []
        groups                  =   {}
        
        hash.each do |key, value|
          if key !~ /_fee$/i
            splitted            =   key.split("_")

            if splitted.size == 2
              currency           =   splitted.first
              value_key          =   splitted.last

              groups[currency]  ||=   {}
              groups[currency][value_key] = value&.to_f
            end
          end
        end
        
        hash.each do |key, value|
          if key =~ /_fee$/i
            pair                =   key.split("_")&.first #btceur_fee -> btceur
            
            groups.keys.each do |grouped_key|
              if pair =~ /^#{grouped_key}/i
                quote_key       =   pair.gsub(grouped_key, "")
                groups[grouped_key]["fees"] ||= {}
                groups[grouped_key]["fees"][quote_key] = value&.to_f
              end
            end
          end
        end
        
        groups                  =   groups.deep_symbolize_keys

        groups.each do |key, values|
          values[:currency]     =   key.to_s.upcase
          parsed               <<   ::Bitstamper::Models::Balance.new(values)
        end
        
        return parsed
      end
      
    end
  end
end
