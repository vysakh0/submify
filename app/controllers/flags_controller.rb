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
    flag = Flag.find_by_id(params[:id])
    @flaggable = flag.flaggable
    flag.destroy
    respond_to do |format|
      format.js
    end
  end
  private
  def get_parent
    @flaggable = Link.find_by_id(params[:flaggable_id]) if params[:flaggable_type] == "Link"
    @flaggable = Comment.find_by_id(params[:flaggable_id]) if params[:flaggable_type] == "Comment"
  end
end
