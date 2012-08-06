require "money/bank/variable_exchange"

class Money
  module Bank
    class PersistentBank < VariableExchange

      class << self
        attr_accessor :default_storage
      end

      attr_accessor :storage

      RATE_FORMAT = :yaml
      CACHE_KEY = 'persistent_bank/rates'

      # Inherited .instance returns VariableExchange for some reason
      def self.instance
        @@pb_singleton ||= new
      end

      def setup
        super
        @storage = self.class.default_storage
        self
      end

      def update_rates
        previous_cache = @rates_cache
        @rates_cache = storage.read(CACHE_KEY)
        return if previous_cache == @rates_cache # Do not reload rates if cache wasn't changed
        rates.clear
        import_rates(RATE_FORMAT, @rates_cache) if @rates_cache
      end

      def get_rate(*)
        update_rates
        super
      end

      def rates(*)
        update_rates
        super
      end

      def save!
        storage.write(CACHE_KEY, export_rates(RATE_FORMAT))
      end

      def destroy
        storage.delete(CACHE_KEY)
      end

    end
  end
end
