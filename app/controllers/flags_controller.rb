class FlagsController < ApplicationController
  before_filter :get_parent, only: :create

  def create
    @flag = Flag.new(params[:flag])
    @flag.flaggable = @flaggable
    @flag.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    flag = Flag.find(params[:id])
    @flaggable = flag.flaggable
    flag.destroy
    respond_to do |format|
      format.js
    end
  end
  private
  def get_parent
    if params[:flaggable_type] == "Link"
      @flaggable = Link.find(params[:flaggable_id]) 
    elsif params[:flaggable_type] == "Comment"
      @flaggable = Comment.find(params[:flaggable_id]) 
    end
  end
end
