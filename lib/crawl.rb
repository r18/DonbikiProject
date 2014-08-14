class Crawler 
  def initialize 
  end

  def fetch_oembed id
    begin 
      body = @client.oembed(id.to_s,{:omit_script=>true, :hide_thread=>true})
      return body.html
    rescue 
      puts body
      return nil
    end
  end

  def save_turntweet tweet
    res = Turntweet.find_by(:tweetId => tweet.id)
    if res then
      return res  
    end
    dtweet = save_dtweet_from_id tweet.in_reply_to_tweet_id.to_s
    user = save_user tweet.user
    if (not dtweet == nil ) && (not user == nil) then
      t = Turntweet.new
      t.tweetId = tweet.id
      t.body  = tweet.text
      t.dtweet = dtweet
      t.user = user 
      t.uri = tweet.uri.to_s
      t.tweetCreatedAt = tweet.created_at.to_s
      t.save
    end
    dtweet.try(:body).to_s
  end

  def save_dtweet_from_id id
    t = Dtweet.find_by(:tweetId => id.to_s)
    if not t then
      begin 
        tweet = @client.status(id)
      rescue 
        return nil
      end 
      res = tweet.text
      user = save_user tweet.user
      if (not res) && (not user) then
        return nil
      else 
        t = Dtweet.new 
        t.tweetId = tweet.id
        t.body = res
        t.user = user
        t.uri = tweet.uri.to_s
        t.tweetCreatedAt = tweet.created_at.to_s
        t.save
      end
    end
    return t
  end

  def save_user user
    t = User.find_by(:userId => user.id)
    if not t then
      t = User.new
      t.name = user.screen_name
      t.userId = user.id
      t.profile_image_url =  user.profile_image_url.to_s
      t.save
    end
    return t
  end

  def crawl
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token= ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret= ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    res = []
    @client.search("%22%e3%83%89%e3%83%b3%e5%bc%95%e3%81%8d%2ecom%22 -rt", :count => 10, :result_type => "recent").collect do |tweet|
      res.push tweet.user.screen_name.to_s
      res.push tweet.text.to_s
      res.push save_turntweet tweet
    end
    res.to_s
  end
end
