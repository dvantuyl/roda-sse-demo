
module MessagesComponent
  class Component
    class << self

      def render
        sseid = SecureRandom.uuid #'Components::Messages::Component'
        FormComponent.render(sseid) +
        ListComponent.render(sseid)
      end

      def stream(out)
        last_timestamp = Time.now.to_i

        while true
          logs = MessageModel.greater_than(last_timestamp)

          if logs.count > 0
            last_timestamp = logs.map {|log| log[:timestamp]}.max
            logs.each(&format_stream_to(out))
          end

          sleep 0.1
        end
      end

      def add(message:, sseid:)
        MessageModel.add(message: message, sseid: sseid)
      end


      private

      def format_stream_to(out)
        ->(log) {
          out << <<~OUT
            event: #{log[:sseid]}
            data: <li>#{log[:message]}</li>
            \n\n
          OUT
        }
      end
    end
  end
end
