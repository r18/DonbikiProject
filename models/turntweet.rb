class Turntweet < ActiveRecord::Base
  validates_uniqueness_of :tweetId
  belongs_to :user
  belongs_to :dtweet
end
