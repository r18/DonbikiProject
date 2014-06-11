require 'json'
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
      @tweets = Dtweet.all.order("updated_at desc").limit(20)
      render 'tweets/index'
    end

    get '/tweets' do
      start = params[:start].to_i
      length = params[:length].to_i
      Dtweet.all.order("updated_at desc")[start..start+length].to_json
    end


    get '/resque' do
      mount Resque::Server.new
    end

    get '/twitter' do
      Resque.enqueue(Worker,"hoge")

      if Resque.all_schedules == nil then
       puts "======EnQUEUE"
      Resque.set_schedule('Crawler', 
                          { :cron => '* * * * *', 
                            :class => 'Worker',
                            :queue => 'twitter', 
                            :args => 'hoge', 
                            :description => 'Crawling Tweets' }
                         )
      end
      Resque.all_schedules.to_s
    end
  end
end
