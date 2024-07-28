require_relative 'form_component'
require_relative 'list_component'

module Components
  module Messages
    class Component
      class << self

        def sseid
          'Components::Messages::Component'
        end

        def render
          FormComponent.render(sseid) +
          ListComponent.render(sseid)
        end

        def stream(out)
          last_timestamp = Time.now.to_i

          while true
            logs = App.db[:messages].where { timestamp > last_timestamp }.all

            if logs.count > 0
              last_timestamp = logs.map {|log| log[:timestamp]}.max
              logs.each(&format_stream_to(out))
            end

            sleep 0.5
          end
        end

        def add(message)
          timestamp = Time.now.to_i
          App.db[:messages].insert(message: message, sseid: sseid, timestamp: timestamp)
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
end
