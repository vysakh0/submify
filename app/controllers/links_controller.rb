require 'open-uri'
require 'uri'
require 'net/http'
require 'nokogiri'
require 'open_uri_redirections'
class LinksController < ApplicationController

  include LinksHelper
  before_filter :signed_in_user, only: [:create, :destroy, :submit]
  before_filter :correct_user, only: [:destroy]

  def index

    final_url  =params[:q]
    final_url.slice! "http://"
    final_url.slice! "https://"
    final_url.slice! "www."
    params[:q] = final_url
    if params[:q]
      @links = Link.search(params)
      respond_to do |format|
        format.js
        format.html
      end
    end

  end
  def show

    @link = Link.find_by_id(params[:id])
    @comments = @link.comments.order('score DESC').paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def submit
    id = params[:link][:id]
    topic = params[:topic_name]
    @link = Link.find_by_id(id)
    if id and topic!= ""
      @link.link_with_topic!(topic, current_user, nil)
      publish_to_fb
      respond_to do |format|
        format.js
      end
    end
  end

  def create
    topic = params[:topic_name]
    @topic = Topic.find_by_id(params[:topic_val]) if params[:topic_val]!=""

    if topic != "" and data=check_url

      if @link= Link.find_by_url_link(params[:link][:url_link])

        if @link.topics.exists? name: topic
          flash[:notice]="Link already submitted to the topic"
        else 
          @link.link_with_topic!(topic, current_user,@topic)

          flash[:success]="Link submitted"
                    publish_to_fb
        end
      else
        @link = current_user.links.build(params[:link]) 

        unless /youtube.com|vimeo.com|twitter.com|soundcloud.com/.match(params[:link][:url_link])
          img = link_image(data)
          @link.picture_from_url(img) if img
        end
        if @link!= nil && @link.save
          @link.link_with_topic!(topic, current_user, @topic)
                   publish_to_fb
          flash[:success]="Link submitted"
        end
      end
    else 
      flash[:error]= "Enter a proper url"

    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def destroy
    unsubmit = LinkUser.find(params[:unsubmit])
    unsubmit.user = nil
    unsubmit.save
    @link_id = params[:link_id]
   topic = Topic.find(params[:topic])
    respond_to do |format|
      format.html { redirect_to topic}
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
   FacebookLinkNotifyWorker.perform_async(link_url(@link))
  end
  def check_url
    count = 0
    given =params[:link][:url_link]
    given = "http://" + given if /https?:\/\/[\S]+/.match(given) == nil
    begin       	
      final_url =  open(given, allow_safe_redirections: true).base_uri.to_s
      data = Nokogiri::HTML(open(final_url))
      final_url.slice! "http://"
      final_url.slice! "https://"
      final_url.slice! "www."
      final_url.slice! '#'+ URI(final_url).fragment if URI(final_url).fragment
      final_url = final_url[0..-2] if final_url[-1]=='/'
      params[:link][:url_link] = final_url
      params[:link][:url_heading] = data.css('title')[0].content
      data 

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
        params[:link][:url_heading] = data.css('title')[0].content
        data
      rescue
        flash[:error] = "Invalid url in uri rescue"
        false
      end	
    rescue Errno::ECONNRESET 
      count  = count + 1 
      retry unless count > 10 
    rescue
      flash[:error] = "Invalid url"
      false
    end
  end   
end

