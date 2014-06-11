class AddDtweetToTurntweet < ActiveRecord::Migration
  def self.up
    change_table :turntweets do |t|
      t.integer :dtweet_id
    end
  end

  def self.down
    change_table :turntweets do |t|
      t.remove :dtweet_id
    end
  end
end
