require 'bundler'
require 'instagram'
require 'oauth'
Bundler.require()

enable :sessions

CALLBACK_URL = "http://localhost:9292/oauth/callback"

Instagram.configure do |config|
  config.client_id = ENV['key']
  config.client_secret = ENV['secret']
  # For secured endpoints only
  #config.client_ips = '<Comma separated list of IPs>'
end

get '/' do
  erb :index
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
    puts response
  session[:access_token] = response.access_token
  redirect "/profile"
end

get '/profile' do
  client = Instagram.client(:access_token => session[:access_token])
  @user = client.user
  erb :profile
end
