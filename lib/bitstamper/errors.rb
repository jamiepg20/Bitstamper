module Bitstamper
  module Errors
    class Error < StandardError; end;
    class MissingConfigError < Bitstamper::Errors::Error; end;
    class InvalidPermissionsError < Bitstamper::Errors::Error; end;
    class InvalidOrderError < Bitstamper::Errors::Error; end;
    class InvalidAmountError < Bitstamper::Errors::Error; end;
    class InvalidAddressError < Bitstamper::Errors::Error; end;
    class InvalidCurrencyError < Bitstamper::Errors::Error; end;
  end
end
