# Write config/database.yml based on $DATABASE_URL
# Replaces the 80-line giant that is database_support.rb

require 'uri'

puts "Writing config/database.yml from $DATABASE_URL"
uri = URI.parse ENV['DATABASE_URL']
ymlfile = File.join(File.join(ENV['HOME'], 'config', 'database.yml'))
adapter = if uri.scheme == "mysql"
            "mysql2"
          else
            "postgresql"
          end
_, _, database = uri.path.rpartition "/"

environment = ENV['RAILS_ENV'] || "production"
pool = ENV['RAILS_DATABASE_POOL'] || 20

File.open(ymlfile, 'w') do |fh|
  fh.puts("#{environment}:
  adapter: #{adapter}
  encoding: utf8
  pool: #{pool}
  reconnect: false
  host: #{uri.host}
  port: #{uri.port}
  username: #{uri.user}
  password: #{uri.password}
  database: #{database}
")
end
