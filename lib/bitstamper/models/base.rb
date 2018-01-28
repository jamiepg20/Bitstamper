module Bitstamper
  module Models
    class Base

      def attributes
        Hash[instance_variables.map { |name| [name.to_s.gsub(/^@/, "").to_sym, instance_variable_get(name)] }]
      end
      
    end
  end
end
