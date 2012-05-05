class SongsController < ApplicationController
  def index
    @songs = Song.order('artist, album').page(params[:page]).per(20)

    if params[:query]
      @songs = @songs.search params[:query]
    end
  end
end
