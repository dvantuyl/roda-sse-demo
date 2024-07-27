require 'sequel'


SSE = Sequel.connect('extralite://db/sse.db')

SSE.drop_table? :logs

SSE.create_table? :logs do
  primary_key :id
  String :message
  Integer :timestamp
end
