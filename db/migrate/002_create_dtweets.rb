class CreateDtweets < ActiveRecord::Migration
  def self.up
    create_table :dtweets do |t|
      t.belongs_to :user
      t.string :tweetId
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :dtweets
  end
end
