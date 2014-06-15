require 'json'
require 'crawl'
require 'worker'
require 'pp'
require 'resque-scheduler'
module DonbikiProject
  class App < Padrino::Application
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    get '/' do
      start = params[:start]||=0
      length = params[:length]||=20
      @tweets = Dtweet.all.order("tweetId desc").offset(start).limit(length)
      render 'tweets/index'
    end

    get '/user' do 
      @users = User.joins(:turntweet).all
      render 'user/index'
    end

    get'/crawl' do
      Crawler.new.crawl
    end

    get '/twitter' do
      Resque.enqueue(Worker,"hoge")
    end
  end
end
