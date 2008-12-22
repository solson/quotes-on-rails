class Ip < ActiveRecord::Base
  has_many :votes
  
  validates_presence_of     :ip
  validates_uniqueness_of   :ip
  validates_numericality_of :ip
  
  def before_save
    IPAddr.new(self.ip).to_i
  end
end
