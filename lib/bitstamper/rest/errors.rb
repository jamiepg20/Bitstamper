module Bitstamper
  module Rest
    module Errors
      
      def error?(response)
        if response.is_a?(Hash)
          if response.has_key?("error")
            process_error(response.fetch("error", nil))
          elsif response.fetch("status", nil) == "error"
            process_error(response.fetch("reason", nil))
          end
        end
      end
      
      def process_error(error)
        if error.is_a?(String)
          if error == ::Bitstamper::Constants::ERRORS[:matches][:invalid_permissions]
            raise ::Bitstamper::Errors::InvalidPermissionsError.new(::Bitstamper::Constants::ERRORS[:responses][:invalid_permissions])
          elsif error == ::Bitstamper::Constants::ERRORS[:matches][:invalid_order]
            raise ::Bitstamper::Errors::InvalidOrderError.new(::Bitstamper::Constants::ERRORS[:matches][:invalid_order])
          end
        elsif error.is_a?(Hash)
          process_hash_error(error)
        end
      end
      
      def process_hash_error(error)
        if error.has_key?("amount")
          raise ::Bitstamper::Errors::InvalidAmountError.new(error.fetch("amount", [])&.first)
        elsif error.has_key?("address")
          raise ::Bitstamper::Errors::InvalidAddressError.new(error.fetch("address", [])&.first)
        elsif error.has_key?("__all__")
          raise ::Bitstamper::Errors::InvalidOrderError.new(error.fetch("__all__", [])&.first)
        end
      end
            
    end
  end  
end
