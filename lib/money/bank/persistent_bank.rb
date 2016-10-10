require "money/bank/variable_exchange"

class Money
  module Bank
    class PersistentBank < VariableExchange
      attr_reader :storage

      def initialize(storage, key = 'persistent_bank/rates', format = :yaml,
                     always_sync = false)
        super()
        @storage = storage
        @storage_key = key
        @storage_format = format
        @always_sync = always_sync
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
        import_rates if !@rates_imported || @always_sync
        super(from, to_currency, &block)
      end
    end
  end
end
