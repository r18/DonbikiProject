
class Worker
  @queue = :default
  def initialize
  end

  def self.perform(name)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token= ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret= ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    client.search("%22%e3%83%89%e3%83%b3%e5%bc%95%e3%81%8d%2ecom%22 -rt", :count => 10, :result_type => "recent").collect do |tweet|
      res = Turntweet.find_by(:tweetId => tweet.id)
      if not tweet.in_reply_to_tweet_id.to_s == "" && res == nil then
        t = Turntweet.new
        t.user = tweet.user.screen_name
        t.tweetId = tweet.id
        t.body = client.oembed(tweet.id.to_s,{:omit_script=>true, :hide_thread=>true}).html
        t.replyId = tweet.in_reply_to_tweet_id
        t.save

        d = Dtweet.find_by(:tweetId => tweet.in_reply_to_tweet_id)
        if d == nil then
          st = client.status(tweet.id)
          d = Dtweet.new
          d.user = st.user.screen_name
          d.body = client.oembed(tweet.in_reply_to_tweet_id.to_s,{:omit_script=>true, :hide_thread=>true}).html
          d.tweetId = tweet.in_reply_to_tweet_id.to_s
        end
        if d.turnId.to_s == "" then
          d.turnId = tweet.id
        elsif not d.turnId.to_s.split(",").include?(tweet.in_reply_to_tweet_id.to_s) then
          d.turnId= d.turnId.to_s + "," + tweet.in_reply_to_tweet_id.to_s
        end 
        d.save


        user = User.find_by(:userId => tweet.user.id)
        if user == nil then 
          user = User.new
          user.userId = tweet.user.id
          user.name = tweet.user.screen_name
          user.save
        end

        if user.turnTweetId.to_s == "" then
          user.turnTweetId = tweet.id.to_s 
        elsif not user.turnTweetId.to_s.split(",").include?(tweet.id.to_s) then
          user.turnTweetId = user.turnTweetId.to_s + "," + tweet.id.to_s
        end 
        user.save
      end
      tweet.id.to_s
    end
  end
end

