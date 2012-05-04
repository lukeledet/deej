class Song < ActiveRecord::Base
  attr_accessible :album, :artist, :length, :genre, :path, :play_count, :title, :playing

  has_many :votes

  def self.search query
    where(["title LIKE ? OR artist LIKE ? OR path LIKE ?", *["%#{query}%"]*3])
  end

  def self.playing
    where('playing is NOT NULL').first
  end

  def self.queue
    select("*, (SELECT COUNT(*) FROM votes WHERE song_id=songs.id AND status='active') AS vote_count")
    .where(["id IN (?)", Vote.top.pluck(:song_id)])
    .order('vote_count DESC')
  end

  def self.next
    top = Vote.top.pluck(:song_id).first

    find_by_id(top) || random
  end

  def self.random
    order('RANDOM()').first
  end

  def to_s
    "#{artist} - #{title}"
  end

  def current_percent
    ((playing / length.to_f) * 100).to_i
  end

  def current_progress
    "#{Time.at(playing).gmtime.strftime('%M:%S')} / #{Time.at(length).gmtime.strftime('%M:%S')}"
  end
end
