class CreateTurntweets < ActiveRecord::Migration
  def self.up
    create_table :turntweets do |t|
      t.string :user
      t.string :tweetId
      t.text :body
      t.string :replyId
      t.timestamps
    end
  end

  def self.down
    drop_table :turntweets
  end
end
