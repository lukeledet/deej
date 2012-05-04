class VotesController < ApplicationController
  def new
    song = Song.find params[:song_id]

    @vote = song.votes.create ip: request.remote_ip
  end
end
