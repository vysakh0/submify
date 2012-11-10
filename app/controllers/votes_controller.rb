class VotesController < ApplicationController
  before_filter :get_parent, only: :create
  def create
    @vote = Vote.new(params[:vote])
    @vote.votable = @votable
    @vote.save
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    vote = Vote.find_by_id(params[:id])
    @votable = vote.votable
    vote.destroy
    respond_to do |format|
      format.js
    end
  end
  private
  def get_parent
    @votable = Link.find_by_id(params[:link_id])
  end
end
