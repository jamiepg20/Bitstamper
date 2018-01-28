module Bitstamper
  class Utilities
    
    class << self
      def fix_currency_pair(currency_pair)
        currency_pair&.to_s&.strip&.downcase
      end
      
      def convert_value(value, type)
        return case type
          when :string
            value.to_s
          when :integer
            value.to_i
          when :float
            value.to_f
          when :boolean
            value.to_s.downcase.eql?("true")
          when :datetime
            DateTime.parse(value)
          when :time
            epoch_to_time(value)
          when :hash
            value.symbolize_keys
          else
            value
        end
      end
      
      def epoch_to_time(epoch)
        ::Time.at(epoch.to_i).utc
      end
      
      def numeric?(string)
        !!Kernel.Float(string) 
      rescue TypeError, ArgumentError
        false
      end
      
      def parse_objects!(string, klass)
        # If Bitstamp returned nothing (which it does if the results yield empty) 'cast' it to an array
        string = "[]" if string == ""

        objects = JSON.parse(string)
        objects.collect do |t_json|
          parse_object!(t_json, klass)
        end
      end

      def parse_object!(object, klass)
        object = JSON.parse(object) if object.is_a? String
        if object["status"] == "error"
          raise ArgumentError.new(object["reason"])
        end

        klass.new(object)
      end
    end
    
  end
end
