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

  desc "Play the songs!"
  task :play => :environment do
    BLOCKSIZE = 16384

    s = Shout.new
    s.mount = "/dj"
    s.host = "localhost"
    s.user = "source"
    s.pass = "hackme"
    s.format = Shout::MP3
    s.name = 'SI DJ'
    s.url = 'http://radio.searchinfluence.com'
    s.genre = 'It takes all kinds'
    s.description ='Your music, voted and random.'

    s.connect

    while true
      song = Song.next
      song.playing = true
      song.play_count += 1
      song.save

      song.votes.update_all status: 'played'

      puts "Playing #{song}"

      File.open(song.path) do |file|
        m = ShoutMetadata.new
        m.add 'filename', song.path
        m.add 'title', song.to_s
        s.metadata = m

        while data = file.read(BLOCKSIZE)
          s.send data
          s.sync
        end

        song.update_attributes playing: false
      end
    end

  end
end