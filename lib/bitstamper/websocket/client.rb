module Bitstamper
  module Websocket
    class Client
      attr_accessor :socket, :application_key, :enable_logging
      attr_accessor :channels, :subscriptions, :callbacks
    
      def initialize(application_key: ::Bitstamper.configuration.pusher_app_key, enable_logging: false)
        self.socket           =   nil
        
        self.application_key  =   application_key
        self.enable_logging   =   enable_logging
      
        self.channels         =   {
          live_trades:      [],
          order_book:       [],
          diff_order_book:  [],
          live_orders:      []
        }
        
        self.subscriptions    =   []
        
        self.callbacks        =   {
          live_trades:      -> (channel, event, data) { received(channel, event, data) },
          order_book:       -> (channel, event, data) { received(channel, event, data) },
          diff_order_book:  -> (channel, event, data) { received(channel, event, data) },
          
          live_orders: {
            order_created:  -> (channel, event, data) { received(channel, event, data) },
            order_changed:  -> (channel, event, data) { received(channel, event, data) },
            order_deleted:  -> (channel, event, data) { received(channel, event, data) }
          }
        }
      
        disable_pusher_logging if !self.enable_logging
        generate_channels
      end
    
      def disable_pusher_logging
        PusherClient.logger   =   Logger.new(nil)
      end
    
      def generate_channels
        ::Bitstamper.configuration.products.each do |product|
          self.channels[:live_trades]       <<    {name: "live_trades_#{product}",     product: product, events: ["trade"]}
          self.channels[:order_book]        <<    {name: "order_book_#{product}",      product: product, events: ["data"]}
          self.channels[:diff_order_book]   <<    {name: "diff_order_book_#{product}", product: product, events: ["data"]}
          self.channels[:live_orders]       <<    {name: "live_orders_#{product}",     product: product, events: ["order_created", "order_changed", "order_deleted"]}
        end
      end
      
      def start!(async: true)
        self.socket   =   PusherClient::Socket.new(self.application_key)
        self.socket.connect(async)
      end
      
      def stop!
        self.socket.disconnect
      end
      
      def subscribe!(type, product: nil)
        chnls     =   self.channels.fetch(type, [])
        chnls     =   chnls&.select { |channel| channel[:product].to_s == product.to_s } if !product.to_s.empty? && product.to_s != "all"
        
        chnls.each do |channel|
          if !self.subscriptions.include?(channel[:name])
            self.socket.subscribe(channel[:name])
            self.subscriptions << channel[:name]
          
            channel[:events].each do |event|
              self.socket[channel[:name]].bind(event) do |data|
                ws_received(channel, event, data)
              end
            end
          end
        end
      end
      
      def loop!
        loop do
          sleep(1)
        end
      end
      
      # Implement your own callback to customize how data is processed
      def received(channel, event, data)
        parsed = case channel[:name]
          when /^live_trades/i
            ::Bitstamper::Models::LiveTrade.new(data.symbolize_keys.merge(product: channel[:product]))
          when /^order_book/i
            ::Bitstamper::Models::OrderBook.new(data)
          when /^diff_order_book/i
            ::Bitstamper::Models::OrderBook.new(data)
          when /^live_orders/i
            ::Bitstamper::Models::Order.new(data.merge(event: event))
        end
        
        pp parsed
      end
      
      private
      def ws_received(channel, event, data)
        data    =   parse(data)
        
        case channel[:name]
          when /^live_trades/i
            self.callbacks[:live_trades].call(channel, event, data)
          when /^order_book/i
            self.callbacks[:order_book].call(channel, event, data)
          when /^diff_order_book/i
            self.callbacks[:diff_order_book].call(channel, event, data)
          when /^live_orders/i
            self.callbacks[:live_orders][:order_created].call(channel, event, data) if event == "order_created"
            self.callbacks[:live_orders][:order_changed].call(channel, event, data) if event == "order_changed"
            self.callbacks[:live_orders][:order_deleted].call(channel, event, data) if event == "order_deleted"
        end
      end
      
      def parse(data)
        return data if data.is_a? Hash
        return JSON.parse(data)
      rescue => err
        return data
      end
      
    end    
  end
end
