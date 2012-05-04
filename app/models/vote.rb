class Vote < ActiveRecord::Base
  belongs_to :song
  attr_accessible :ip

  scope :active, where(status: 'active')
end
