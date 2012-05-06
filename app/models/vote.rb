class Vote < ActiveRecord::Base
  attr_accessible :ip, :status

  validates :ip, uniqueness: {scope: [:status, :song_id]}
  validates :status, inclusion: { in: %w{active skip played old_skip}}

  belongs_to :song

  scope :active, where(status: 'active')
  scope :skips,  where(status: 'skip')
end
