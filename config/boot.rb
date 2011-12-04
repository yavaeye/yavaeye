require "fileutils"

FileUtils.cd File.dirname File.dirname __FILE__

require "bundler"
ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require_relative 'database'
Dir.glob("./lib/**/*.rb") { |f| require f }
Secret.init

set :root, File.expand_path('.')
set :views, settings.root + '/app/views'
set :method_override, true # allow _method=put, _method=delete params

set :sessions, true
use Rack::Session::Cookie,
  key: 'rack.session',
  domain: (ENV['RACK_ENV'] =~ /development|test/ ? nil : 'yavaeye.com'),
  path: '/',
  secret: Secret.session_secret,
  httponly: true

# oauth app token
set :github, YAML::load_file(settings.root + '/config/oauth.yml')['github']

# csrf
use Rack::YavaProtection

configure :development do
  also_reload "lib/**/*.rb", "app/{models,helpers}/*.rb"
  require "./script/asset"
  # proxy for openid
  if port = ENV['openid_proxy_port']
    puts "=> Using proxy for openid request"
    proxy = Net::HTTP.SOCKSProxy '127.0.0.1', port.to_i
    OpenID.fetcher.instance_variable_set :@proxy, proxy
  end
  $asset = Asset.new
  before { I18n.locale = :'zh-CN'; $asset.compile }
end

puts "=> Loading I18n"
YavaUtils.load_i18n settings.root

Dir.glob("./{app/models,app/helpers,app/controllers}/*.rb") { |f| require f }
