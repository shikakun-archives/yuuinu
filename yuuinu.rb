# coding: utf-8

Sequel::Model.plugin(:schema)

db = {
  user:     ENV['USER'],
  dbname:   ENV['DBNAME'],
  password: ENV['PASSWORD'],
  host:     ENV['HOST']
}

configure :development do
  DB = Sequel.connect("sqlite://database.db")
end

configure :production do
  DB = Sequel.connect("mysql2://#{db[:user]}:#{db[:password]}@#{db[:host]}/#{db[:dbname]}")
end

class Database < Sequel::Model
  unless table_exists?
    set_schema do
      primary_key :id
      String :uid
      String :nickname
      String :image
      String :token
      String :secret
      DateTime :created_at
      DateTime :updated_at
    end
    create_table
  end
end

use Rack::Session::Cookie,
  :key => 'rack.session',
  :path => '/',
  :expire_after => 3600,
  :secret => ENV['SESSION_SECRET']

use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
end

before do
  Twitter.configure do |config|
    config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
    config.oauth_token        = session['token']
    config.oauth_token_secret = session['secret']
  end
end

def tweet(tweets)
  if settings.environment == :production
    twitter_client = Twitter::Client.new
    twitter_client.update(tweets)
  elsif settings.environment == :development
    flash.next[:info] = tweets
  end
end

not_found do
  redirect "/"
end

error do
  redirect "/" 
end

get "/" do
  @checkins = Database.order_by(:id.desc)
  slim :index
end

get "/auth/:provider/callback" do
  auth = request.env['omniauth.auth']
  session['uid'] = auth['uid']
  session['nickname'] = auth['info']['nickname']
  session['image'] = auth['info']['image']
  session['token'] = auth['credentials']['token']
  session['secret'] = auth['credentials']['secret']
  tweet('悠になりたかった犬にいます http://yuui.nu/')
  Database.create(
    :uid => session['uid'],
    :nickname => session['nickname'],
    :image => session['image'],
    :token => session['token'],
    :secret => session['secret']
  )
  redirect "/"
end
