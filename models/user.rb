class User < ActiveRecord::Base
  validates_uniqueness_of :userId
  has_many :turntweet
  has_many :dtweet
end
