require "money/bank/variable_exchange"

class Money
  module Bank
    class PersistentBank < VariableExchange
      attr_reader :storage

      def initialize storage, key = 'persistent_bank/rates', format = :yaml
        super()
        @storage = storage
        @storage_key = key
        @storage_format = format
      end

      def export_rates
        storage.write(@storage_key, super(@storage_format))
      end

      def import_rates
        rates.clear
        cache = storage.read(@storage_key)
        @rates_imported = true
        super(@storage_format, cache) if cache
      end

      def clear
        storage.delete(@storage_key)
      end

      def exchange_with(from, to_currency, &block)
        import_rates unless @rates_imported
        super(from, to_currency, block)
      end
    end
  end
end
