class Song < ActiveRecord::Base
  attr_accessible :album, :artist, :length, :genre, :path, :play_count, :title, :playing

  has_many :votes

  def self.search query
    where "title LIKE :q OR artist LIKE :q OR path LIKE :q", q: "%#{query}%"
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
    Vote.skips.update_all status: 'old_skip'
  end

  def to_s
    "#{artist} - #{title}"
  end

  def current_percent
    ((playing / length.to_f) * 100).to_i
  end

  # Not sure where to put this but Song.playing.current_listeners seemed ok
  def current_listeners
    return @current_listeners if @current_listeners
    return if CONFIG['icecast']['admin_user'].blank?

    # admin_url is set in the app config initializer as a "helper"
    xml = open(CONFIG['icecast']['admin_url'] + "/listclients?mount=#{CONFIG['icecast']['mount']}",
          http_basic_authentication: [CONFIG['icecast']['admin_user'],CONFIG['icecast']['admin_pass']])
    stats = Hash.from_xml xml.read

    @current_listeners = stats['icestats']['source']['Listeners'].to_i
  end

  def skip?
    votes.skips.count > 0 && votes.skips.count >= current_listeners / 2
  end
end
