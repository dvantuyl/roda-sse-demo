module Components
  module Messages
    class MessageModel
      class << self
        def db
          Sequel.connect("extralite://db/sse.db")
        end

        def greater_than(last_timestamp)
          db[:messages].where { timestamp > last_timestamp }.all
        end

        def add(message:, sseid:)
          timestamp = Time.now.to_i
          db[:messages].insert(message: message, sseid: sseid, timestamp: timestamp)
        end
      end
    end
  end
end
