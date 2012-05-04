class Song < ActiveRecord::Base
  attr_accessible :album, :artist, :length, :path, :play_count, :title
end
