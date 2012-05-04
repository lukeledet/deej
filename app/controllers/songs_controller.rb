class SongsController < ApplicationController
  def index
    @songs = Song.order('artist, album').page(params[:page]).per(15)

    if params[:query]
      @songs = @songs.search params[:query]
    end
  end
end
