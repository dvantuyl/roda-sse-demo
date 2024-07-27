require 'roda'
require 'json'

class App < Roda
  LOG_FILE_PATH = "./logs/#{ENV['RACK_ENV'] || 'development'}.log"

  plugin :common_logger, $stdout
  plugin :streaming
  plugin :render, views: 'app/views'

  # Shared data structure to hold log events
  SSE = Sequel.connect('extralite://db/sse.db')

  def self.logger
    self.opts[:common_logger]
  end

  route do |r|
    r.root do
      render('index')
    end

    r.get "events" do
      response['Content-Type'] = 'text/event-stream'
      stream(loop: true, async: true) do |out|

        last_created_at = Time.now.to_i

        App.logger << "SSE: Connected to /events"

        while true
          logs = SSE[:logs].where { created_at > last_created_at }.all
          if logs.count > 0
            App.logger << "SSE: Sending logs: #{logs}"
            last_created_at = logs.map {|log| log[:created_at]}.max
            App.logger << "SSE: Last created_at: #{last_created_at}"
            out << "data: <div>#{logs.map {|log| log[:event]}}</div>\n\n"
          end

          sleep 3
        end
      end
    end

    r.post "log" do
      new_log_event = r.body.read
      SSE[:logs].insert(event: new_log_event, created_at: Time.now.to_i)
      response.status = 200

      <<~HTML
      <form hx-post="/log">
        <input type="text" name="log" placeholder="Enter another log message">
        <button type="submit">Submit</button>
      </form>
      HTML
    end

  end
end
