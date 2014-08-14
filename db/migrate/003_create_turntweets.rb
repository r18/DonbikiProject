class CreateTurntweets < ActiveRecord::Migration
  def self.up
    create_table :turntweets do |t|
      t.belongs_to:user
      t.string :tweetId
      t.text :body
      t.belongs_to :dtweet
      t.string :uri
      t.string :tweetCreatedAt
      t.timestamps
    end
  end

  def self.down
    drop_table :turntweets
  end
end
