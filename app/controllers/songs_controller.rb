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
          playing: Song.playing.to_s
        }.to_json
      end
    end
  end
end
