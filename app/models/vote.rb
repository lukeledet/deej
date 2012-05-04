class Vote < ActiveRecord::Base
  attr_accessible :ip

  validates :ip, uniqueness: {scope: [:status, :song_id]}

  belongs_to :song

  scope :active, where(status: 'active')
  scope :top, active.group(:song_id).order('COUNT(*) DESC')
end
