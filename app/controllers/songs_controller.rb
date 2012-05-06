class SongsController < ApplicationController
  def index
    @songs = Song.order('artist, album').page(params[:page]).per(20)

    if params[:query]
      @songs = @songs.search params[:query]
    end
  end

  def queue
    respond_to do |format|
      format.html { render partial: 'queue'}
      format.json do
        render json: {
          playing: Song.playing.to_s,
          listeners: Song.playing.current_listeners
        }.to_json
      end
    end
  end

  def download
    song = Song.find params[:id]
    song.downloads += 1
    song.save

    send_data open(song.path).read, filename: File.basename(song.path)
  end
end
