module Bitstamper
  class Configuration
    attr_accessor :key, :secret, :client_id, :pusher_app_key, :faraday, :products
    
    def initialize
      self.key              =   nil
      self.secret           =   nil
      self.client_id        =   nil
      
      self.pusher_app_key   =   "de504dc5763aeef9ff52"
      
      self.faraday          =   {
        adapter:    :net_http,
        user_agent: 'Bitstamp Ruby',
        verbose:    false
      }
      
      self.products         =   [
        "btceur",
        "eurusd",
        "xrpusd",
        "xrpeur",
        "xrpbtc",
        "ltcusd",
        "ltceur",
        "ltcbtc",
        "ethusd",
        "etheur",
        "ethbtc",
        "bchusd",
        "bcheur",
        "bchbtc"
      ]
    end
    
    def verbose_faraday?
      self.faraday.fetch(:verbose, false)
    end
    
  end
end
