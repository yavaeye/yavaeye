require "fileutils"

FileUtils.cd File.dirname File.dirname __FILE__

require "bundler"
ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require_relative 'database'
require "./lib/secret"
require "./lib/yava_protection"
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

# csrf
use Rack::YavaProtection

configure :development do
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
I18n.locale = :'zh-CN'
I18n.load_path = I18n.load_path.map do |f|
  f.sub!(/en\.yml$/, 'zh-CN.yml')
  f if File.exist? f
end.compact
I18n.load_path << settings.root + '/config/zh-CN.yml'
I18n.reload!

#oauth-token
GITHUB = YAML::load(File.read(settings.root + '/config/oauth.yml'))['github']

Dir.glob "./{lib,app/models,app/helpers,app/controllers}/*.rb" do |f|
  require f
end
