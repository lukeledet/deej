class Vote < ActiveRecord::Base
  attr_accessible :ip

  validates :ip, uniqueness: {scope: [:status, :song_id]}

  belongs_to :song

  scope :active, where(status: 'active')
end
