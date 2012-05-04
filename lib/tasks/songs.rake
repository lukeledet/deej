namespace :songs do
  desc "Import the ID3 info of the songs in the database"
  task :import => :environment do
    abort("ENV['MUSIC_DIR'] must be set") unless ENV['MUSIC_DIR']

    Dir[ENV['MUSIC_DIR'] + '/**/*.{mp3,mp4}'].each do |filename|
      next if Song.find_by_path(filename)

      TagLib::FileRef.open(filename) do |file|
        tag   = file.tag
        audio = file.audio_properties

        next if Song.exists? artist: tag.artist, title: tag.title

        song = Song.create({
          artist: tag.artist,
          album:  tag.album,
          title:  tag.title,
          genre:  tag.genre,
          path:   filename,
          length: audio.length
        })
      end
    end
  end
end