module Bitstamper
  module Rest
    module Private
      module Transactions
            
        def user_transactions(currency_pair: nil, offset: 0, limit: 100, sort: "desc")
          path      =   path_with_currency_pair("/v2/user_transactions", currency_pair)
          response  =   post(path, data: {offset: offset, limit: limit, sort: sort})
          Bitstamper::Models::UserTransaction.parse(response) if response
        end

        def find_user_transaction(transaction_id)
          user_transactions.select { |transaction| transaction.id == transaction_id }&.first
        end

      end
    end
  end
end
