require 'roda'
require_relative './components/messages/component'

class App < Roda
  plugin :common_logger, $stdout
  plugin :streaming

  def self.logger
    self.opts[:common_logger]
  end

  route do |r|
    r.root do
      <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SSE Example</title>
        <script src="https://unpkg.com/htmx.org@2.0.1" integrity="sha384-QWGpdj554B4ETpJJC9z+ZHJcA/i59TyjxEPXiiUgN2WmTyV5OEZWCD6gQhgkdpB/" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/htmx-ext-sse@2.2.1/sse.js"></script>
      </head>
      <body>
      #{Components::Messages::Component.render()}
      </body>
      </html>
      HTML
    end

    r.get "messages" do
      response['Content-Type'] = 'text/event-stream'
      stream(loop: true, async: true) do |out|
        Components::Messages::Component.stream(out)
      end
    end

    r.post "message" do
      Components::Messages::Component.add(r.params["message"])

      "ok"
    end

  end
end
