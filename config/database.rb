host = 'localhost'
port = Mongo::Connection::DEFAULT_PORT

database_name = case ENV['RACK_ENV'].to_sym
  when :development then 'development'
  when :production  then 'production'
  when :test        then 'test'
end
Mongoid.database = Mongo::Connection.new(host, port).db(database_name)

