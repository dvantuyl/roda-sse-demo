module Components
  module Messages
    class ListComponent
      class << self
        def render(sseid)
          <<~HTML
          <ul hx-ext="sse"
            sse-connect="/messages"
            sse-swap="#{sseid}"
            hx-swap="afterbegin">
          </ul>
          HTML
        end

        def render_message(message)
          <<~HTML
          <li>#{message}</li>
          HTML
        end
      end
    end
  end
end
