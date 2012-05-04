class Song < ActiveRecord::Base
  attr_accessible :album, :artist, :length, :genre, :path, :play_count, :title

  has_many :votes

  def self.next
    top = Vote.active.group(:song_id).order("COUNT(*) DESC").pluck(:song_id).first

    find_by_id(top) || random
  end

  def self.random
    order('RANDOM()').first
  end

  def to_s
    "#{artist} - #{title}"
  end
end
