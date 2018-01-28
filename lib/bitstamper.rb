# Rest API
require "faraday"
require "faraday_middleware"
require "hmac-sha2"

# Websockets
require "pusher-client"

# Shared
require "json"
require "date"

# Library
require "bitstamper/version"

require "bitstamper/configuration"
require "bitstamper/errors"
require "bitstamper/constants"
require "bitstamper/utilities"

require "bitstamper/models/base"
require "bitstamper/models/balance"
require "bitstamper/models/order"
require "bitstamper/models/order_book"
require "bitstamper/models/ticker"
require "bitstamper/models/user_transaction"
require "bitstamper/models/transaction"
require "bitstamper/models/trading_pair"
require "bitstamper/models/deposit"
require "bitstamper/models/withdrawal"
require "bitstamper/models/live_trade"

require "bitstamper/rest/public/ticker"
require "bitstamper/rest/public/order_book"
require "bitstamper/rest/public/transactions"
require "bitstamper/rest/public/trading_pairs"
require "bitstamper/rest/public/currencies"

require "bitstamper/rest/private/balances"
require "bitstamper/rest/private/deposits"
require "bitstamper/rest/private/withdrawals"
require "bitstamper/rest/private/orders"
require "bitstamper/rest/private/transactions"

require "bitstamper/rest/errors"
require "bitstamper/rest/client"

require "bitstamper/websocket/client"

if !Hash.instance_methods(false).include?(:symbolize_keys)
  require "bitstamper/extensions/hash"
end

module Bitstamper
  
  class << self
    attr_writer :configuration
  end
  
  def self.configuration
    @configuration ||= ::Bitstamper::Configuration.new
  end

  def self.reset
    @configuration = ::Bitstamper::Configuration.new
  end

  def self.configure
    yield(configuration)
  end

end
