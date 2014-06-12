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
      @tweets = Dtweet.all.order("tweetId desc").limit(20)
      render 'tweets/index'
    end

    get '/tweets' do
      start = params[:start].to_i
      length = params[:length].to_i
      Dtweet.joins(:user).order("tweetId desc").offset(start).limit(length).to_json
    end


    get '/resque' do
      mount Resque::Server.new
    end

    get'/crawl' do
      c = Crawler.new
      c.crawl
    end

    get '/twitter' do
      Resque.enqueue(Worker,"hoge")
    end
  end
end
