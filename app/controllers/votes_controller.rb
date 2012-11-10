class VotesController < ApplicationController
  
  def create
    @vote = Vote.create(params[:vote])
    @votable = @vote.votable
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    vote = Vote.find_by_id(params[:id]).destroy
    @votable = vote.votable
    respond_to do |format|
      format.js
    end
  end

end
