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

    r.get "messages" do
      response['Content-Type'] = 'text/event-stream'
      stream(loop: true, async: true) do |out|

        last_timestamp = Time.now.to_i

        App.logger << "CONNECTED => /messages"

        while true
          logs = SSE[:logs].where { timestamp > last_timestamp }.all
          if logs.count > 0
            App.logger << "RECIEVED: #{logs}"
            last_timestamp = logs.map {|log| log[:timestamp]}.max
            out << "data: #{logs.map {|log| '<li>' + log[:message] + '</li>'}.join('')}\n\n"
          end

          sleep 0.5
        end
      end
    end

    r.post "log" do
      new_message = r.body.read.split('=').last
      SSE[:logs].insert(message: new_message, timestamp: Time.now.to_i)
      response.status = 200

      <<~HTML
      <input type="text" name="message" placeholder="Enter your message">
      <button type="submit">Submit</button>
      HTML
    end

  end
end
