require 'forwardable'
require 'csv'

module BuckarooClient
  module Gateway
    class Batch
      attr_reader :transactions

      extend Forwardable
      def_delegators :@transactions, :<<, :size, :each

      def initialize(args = {})
        @transactions = args.fetch(:transactions, [])
      end

      def to_csv
        table = CSV::Table.new([])
        transactions.each { |t| table << transaction_to_csv(t) }
        table.to_csv(col_sep: ';')
      end

      private

      def transaction_to_csv(transaction)
        data = transaction.gateway_attributes
        CSV::Row.new(data.keys, data.values)
      end

    end
  end
end
