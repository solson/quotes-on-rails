class AddPositiveBooleanToVote < ActiveRecord::Migration
  def self.up
    add_column :votes, :positive, :boolean
  end

  def self.down
    remove_column :votes, :positive
  end
end
