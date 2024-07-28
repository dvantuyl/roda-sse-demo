module Components
  module Messages
    class FormComponent
      class << self
        def render(sseid)
          <<~HTML
          <form hx-post="/message" hx-swap="none">
            <input type="hidden" name="sseid" value="#{sseid}">
            <input type="text" name="message" placeholder="Enter your message" autofocus>
            <button type="submit">Submit</button>
          </form>
          HTML
        end
      end
    end
  end
end
