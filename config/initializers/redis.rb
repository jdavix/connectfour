if Rails.env.production?
  uri = URI.parse(ENV["REDISTOGO_URL"])
  options = { :host => uri.host, :port => uri.port, :password => uri.password }
else
  options = { :host => "localhost",
              :port => "6379"}
end
$redis = Redis.new(options)