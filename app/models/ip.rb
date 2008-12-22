class Ip < ActiveRecord::Base
  has_many :votes
  
  validates_presence_of     :ip
  validates_uniqueness_of   :ip
  validates_numericality_of :ip
end
