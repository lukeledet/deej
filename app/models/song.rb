class Song < ActiveRecord::Base
  attr_accessible :album, :artist, :length, :genre, :path, :play_count, :title, :playing

  has_many :votes

  def self.search query
    where(["title LIKE ? OR artist LIKE ? OR path LIKE ?", *["%#{query}%"]*3])
  end

  def self.playing
    where('playing is NOT NULL').first
  end

  # Sort songs by number of votes then earliest vote
  def self.queue
    find_by_sql %q{
      select s.*, vote_count
      from songs s,
        (select count(*) as vote_count, song_id, min(created_at) as created_at
         from votes
         where status='active'
         group by song_id) v
      where s.id=v.song_id order by v.created_at
    }
  end

  def self.next
    queue.first || random
  end

  def self.random
    order('RANDOM()').first
  end

  def self.stop_playing!
    self.update_all playing: nil
  end

  def to_s
    "#{artist} - #{title}"
  end

  def current_percent
    ((playing / length.to_f) * 100).to_i
  end
end
