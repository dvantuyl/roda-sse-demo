module MessagesComponent
  class MessageModel
    class << self
      def greater_than(last_timestamp)
        db[:messages].where { timestamp > last_timestamp }.all
      end

      def add(message:, sseid:)
        timestamp = Time.now.to_i
        db[:messages].insert(message: message, sseid: sseid, timestamp: timestamp)
      end

      private

      def db
        Sequel.connect("extralite://db/sse.db")
      end
    end
  end
end
