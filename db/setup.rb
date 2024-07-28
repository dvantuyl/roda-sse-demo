require 'sequel'


SSE = Sequel.connect('extralite://db/sse.db')

SSE.drop_table? :messages

SSE.create_table? :messages do
  primary_key :id
  String :sseid
  String :message
  Integer :timestamp
end
