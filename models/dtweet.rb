class Dtweet < ActiveRecord::Base
  belongs_to :user
  has_many :turntweet
end
