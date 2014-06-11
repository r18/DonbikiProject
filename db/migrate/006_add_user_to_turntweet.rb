class AddUserToTurntweet < ActiveRecord::Migration
  def self.up
    change_table :turntweets do |t|
      t.integer :user_id
    end
  end

  def self.down
    change_table :turntweets do |t|
      t.remove :user_id
    end
  end
end
