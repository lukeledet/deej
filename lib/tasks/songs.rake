require 'open-uri'

namespace :songs do
  desc "Import the ID3 info of the songs in the database"
  task :import => :environment do
    Dir[CONFIG['music_dir'] + '/**/*.mp3'].each do |filename|
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

    trap("INT") do
      Song.stop_playing!
      abort('Quitting')
    end

    s = Shout.new
    s.host  = CONFIG['icecast']['host']
    s.pass  = CONFIG['icecast']['source_pass']
    s.mount = CONFIG['icecast']['mount']

    s.name  = CONFIG['icecast']['name']
    s.url   = CONFIG['icecast']['url']
    s.genre = CONFIG['icecast']['genre']
    s.description =CONFIG['icecast']['description']

    s.format = Shout::MP3

    s.connect rescue abort('Can not connect to the icecast server')

    while true
      Song.stop_playing!

      song = Song.next
      song.play_count += 1
      song.save

      song.votes.update_all status: 'played'

      puts "Playing #{song}"

      # This is ugly but Shout::Metadata isn't working
      # full_url is set in the app config initializer as a "helper"
      open("#{CONFIG['icecast']['admin_url']}/metadata?" +
           "mount=#{CONFIG['icecast']['mount']}&" +
           "mode=updinfo&song=#{URI.encode song.to_s}",
           http_basic_authentication: [CONFIG['icecast']['admin_user'],CONFIG['icecast']['admin_pass']])

      File.open(song.path) do |file|
        song.update_attributes playing: Time.now

        while data = file.read(BLOCKSIZE)
          s.send data rescue Song.stop_playing! && abort('Lost connection to icecast server')
          s.sync

          break if Song.playing.skip?
        end

      end
    end

  end
end
