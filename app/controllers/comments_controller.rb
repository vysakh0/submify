#
# Submify - Dashboard of web and web activity
# Copyright (C) 2013 Vysakh Sreenivasan <support@submify.com>
#
# This file is part of Submify.
#
# Submify is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Submify is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Submify.  If not, see <http://www.gnu.org/licenses/>.
#
class CommentsController < ApplicationController
  before_filter :get_parent, only: :create
  before_filter :correct_user, only: :destroy
  def new
    @comment = @parent.comments.build
    @comment.user = current_user
    #publish_to_fb if @parent.class.to_s == "Link"
  end

  def show

    @comment = Comment.find(params[:id])
    @comments = @comment.comments.where('score > -10')
    @downvoted_comments = @comment.comments.where('score < -10').exists?
    respond_to do |format|
      format.html
      format.js
    end
  end

  def downvoted
    @comment = Comment.find(params[:id])
    @comments = @comment.comments.where("score <= -10")
  end
  def create
    @comment = @parent.comments.build(params[:comment])
    if params[:comment][:body]!=''
      @comment.user = current_user
      if @comment.save
        #publish_to_fb if @parent.is_a? Link
      else
        flash[:notice] = "Could not add comment, try again"
      end

    end
      respond_to do |format|
        format.html { redirect_to @parent }
        format.js
       end
  end

  def destroy
    if @comment
      @comment_id = params[:id]
      @comment.destroy
    end
    respond_to do |format|
      format.html { redirect_to @parent }
      format.js 
    end
  end

  protected

  def get_parent
    if params[:val]=="1"     
    @parent = Link.find(params[:comment_id]) 
    else
    @parent = Comment.find(params[:comment_id]) 
    end
  end

  def correct_user

    @comment = Comment.find(params[:id])
    @parent = @comment.commentable       
    redirect_to @parent unless current_user?(@comment.user)

  end

  def publish_to_fb
  FacebookCommentNotifyWorker.perform_async(current_user.oauth_token, comment_url(@comment), @comment.body) 
  end
end