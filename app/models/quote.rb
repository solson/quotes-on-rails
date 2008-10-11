class Quote < ActiveRecord::Base
  has_many :votes
  has_many :positive_votes, :class_name => "Vote", :conditions => ["positive = ?", true]
  has_many :negative_votes, :class_name => "Vote", :conditions => ["positive = ?", false]
  has_many :voters, :through => :votes, :source => :ip
  attr_accessible :quote, :comment
end
