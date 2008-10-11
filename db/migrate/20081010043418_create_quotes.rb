class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.integer :votes_count, :default => 0
      t.text :quote
      t.text :comment
      t.boolean :approved, :default => false
      t.integer :reported, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
