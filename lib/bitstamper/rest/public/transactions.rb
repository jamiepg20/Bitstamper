module Bitstamper
  module Rest
    module Public
      module Transactions
      
        def transactions(currency_pair = "btcusd", time: :hour)
          response  =   get(path_with_currency_pair("/v2/transactions", currency_pair), params: {time: time})
          Bitstamper::Models::Transaction.parse(response) if response
        end

        def find_transaction(transaction_id)
          transactions.select { |transaction| transaction.id == transaction_id }&.first
        end
      
      end
    end
  end
end
