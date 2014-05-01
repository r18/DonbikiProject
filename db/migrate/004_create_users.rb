class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :userId
      t.string :dtweetId
      t.string :turnTweetId
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
