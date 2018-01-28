module Bitstamper
  module Rest
    class Client
      attr_accessor :url, :configuration
      
      def initialize(configuration: ::Bitstamper.configuration)
        self.url              =   "https://www.bitstamp.net/api"
        self.configuration    =   configuration
      end
      
      include ::Bitstamper::Rest::Errors
      
      include ::Bitstamper::Rest::Public::Ticker
      include ::Bitstamper::Rest::Public::OrderBook
      include ::Bitstamper::Rest::Public::Transactions
      include ::Bitstamper::Rest::Public::TradingPairs
      include ::Bitstamper::Rest::Public::Currencies
      
      include ::Bitstamper::Rest::Private::Balances
      include ::Bitstamper::Rest::Private::Deposits
      include ::Bitstamper::Rest::Private::Withdrawals
      include ::Bitstamper::Rest::Private::Orders
      include ::Bitstamper::Rest::Private::Transactions

      def configured?
        !self.configuration.key.to_s.empty? && !self.configuration.secret.to_s.empty? && !self.configuration.client_id.to_s.empty?
      end

      def check_credentials!
        unless configured?
          raise ::Bitstamper::Errors::MissingConfigError.new("Bitstamp Gem not properly configured")
        end
      end
      
      def path_with_currency_pair(path, currency_pair)
        path += "/#{::Bitstamper::Utilities.fix_currency_pair(currency_pair)}" if !currency_pair.to_s.empty?
        return path
      end
      
      def to_uri(path)
        "#{self.url}#{path}/"
      end
      
      def parse(response)
        error?(response)
        response
      end

      def get(path, params: {}, options: {})
        request path, method: :get, options: options
      end

      def post(path, params: {}, data: {}, options: {})
        request path, method: :post, params: params, data: data.merge(auth), options: options
      end

      def auth(data = {})
        if configured?
          data[:key]          =   self.configuration.key
          data[:nonce]        =   (Time.now.to_f * 1_000_000_000).to_i.to_s
          message             =   data[:nonce] + self.configuration.client_id.to_s + data[:key]
          data[:signature]    =   HMAC::SHA256.hexdigest(self.configuration.secret, message).upcase
        end

        return data
      end

      def request(path, method: :get, params: {}, data: {}, options: {})
        user_agent    =   options.fetch(:user_agent, self.configuration.faraday.fetch(:user_agent, nil))
        proxy         =   options.fetch(:proxy, nil)
    
        connection    =   Faraday.new(url: to_uri(path)) do |builder|
          builder.headers[:user_agent] = user_agent if !user_agent.to_s.empty?
          builder.request  :url_encoded if method.eql?(:post)
          builder.response :logger      if self.configuration.verbose_faraday?
          builder.response :json
      
          if proxy
            puts "[Bitstamper::Rest::Client] - Will connect to Bitstamp using proxy: #{proxy.inspect}" if self.configuration.verbose_faraday?
            builder.proxy = proxy
          end
      
          builder.adapter self.configuration.faraday.fetch(:adapter, :net_http)
        end
    
        case method
          when :get
            connection.get do |request|
              request.params  =   params if params && !params.empty?
            end&.body
          when :post
            connection.post do |request|
              request.body    =   data
              request.params  =   params if params && !params.empty?
            end&.body
        end
      end
            
    end
  end  
end

