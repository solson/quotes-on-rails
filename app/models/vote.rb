class Vote < ActiveRecord::Base
  belongs_to :quote, :counter_cache => true
  belongs_to :ip
end
