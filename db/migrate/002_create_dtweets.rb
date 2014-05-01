class CreateDtweets < ActiveRecord::Migration
  def self.up
    create_table :dtweets do |t|
      t.string :user
      t.string :tweetId
      t.text :body
      t.string :turnId
      t.timestamps
    end
  end

  def self.down
    drop_table :dtweets
  end
end
