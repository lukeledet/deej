class VotesController < ApplicationController
  def new
    @song = Song.find params[:song_id]

    @vote = @song.votes.new ip: request.remote_ip
    @vote.status = params[:status] if params[:status]
    @vote.save
  end

  def destroy
    @song = Song.find params[:song_id]

    @vote = Vote.find params[:id]
    @vote.destroy

    render action: :new
  end
end
