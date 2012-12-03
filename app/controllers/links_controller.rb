require 'open-uri'
require 'uri'
require 'net/http'
require 'nokogiri'
class LinksController < ApplicationController

  before_filter :signed_in_user, only: [:create, :destroy, :submit]
  before_filter :correct_user, only: [:destroy]
  def show

    @link = Link.find_by_id(params[:id])
    @comments = @link.comments.paginate(page: params[:page])
  end

  def submit
    id = params[:link][:id]
    if id
      @link = Link.find_by_id(id)
      current_user.link_with_user!(@link)
      publish_to_fb
      respond_to do |format|
        format.js
      end
    end
  end

  def create
    topic = params[:topic]
    if check_url

      if @link= Link.find_by_url_link(params[:link][:url_link])

        if !@link.users.exists? current_user and  !@link.topics.exists? topic
          current_user.link_with_user!(@link) 
          @link.link_with_topic!(topic)
        end

        flash[:success] = "Link submitted"
        publish_to_fb
        redirect_to root_url
      else
        @link = current_user.links.build(params[:link]) 

        if @link!= nil && @link.save

          current_user.link_with_user!(@link)
          @link.link_with_topic!(topic)
          flash[:success] = "Link submitted"
          publish_to_fb
          redirect_to root_url
        else
          redirect_to root_url
        end
      end
    else
      redirect_to root_url
    end
  end

  def destroy

    current_user.unlink_with_user!(@link)
    respond_to do |format|
      format.js
    end

  end

  private
  def correct_user
    if params[:id] != nil
      id = params[:id] 
    else
      id = params[:link][:id]
    end
    @link = current_user.links.find_by_id(id)
  end

  def publish_to_fb
    app = FbGraph::Application.new("295241533825642")
    me = FbGraph::User.me(current_user.oauth_token)
    action = me.og_action!(
      app.og_action(:submit), # or simply "APP_NAMESPACE:ACTION" as String
      :website => link_url(@link)
    )
  end
  def check_url
    given =params[:link][:url_link]
    given = "https://" + given if /https?:\/\/[\S]+/.match(given) == nil
    begin       	
      final_url =  open(given).base_uri.to_s
      data = Nokogiri::HTML(open(final_url))
      final_url.slice! "http://"
      final_url.slice! "https://"
      final_url.slice! "www."
      final_url.slice! '#'+ URI(final_url).fragment if URI(final_url).fragment
      final_url = final_url[0..-2] if final_url[-1]=='/'
      params[:link][:url_link] = final_url
      params[:link][:url_heading] = data.css('title')[0].content
      true

    rescue URI::InvalidURIError
      host = given.match(".+\:\/\/([^\/]+)")[1]
      path = given.partition(host)[2] || "/"
      path= "/" if path== ""
      begin    		
        doc = Net::HTTP.get host, path
        given.slice! "http://"
        given.slice! "https://"
        given.slice! "www."
        data = Nokogiri::HTML(doc)	
        params[:link][:url_link] = given
        params[:link][:url_heading] = doc.css('title')[0].content
        true
      rescue
        flash[:error] = "Invalid url in uri rescue"
        false
      end	
    rescue
      flash[:error] = "Invalid url"
      false
    end
  end   
end

