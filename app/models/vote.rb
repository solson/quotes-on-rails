class Vote < ActiveRecord::Base
  belongs_to :quote
  belongs_to :ip
  
  validates_uniqueness_of :ip_id, :scope => :quote_id, :message => "already voted on this quote"
end
