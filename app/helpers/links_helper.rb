require 'open-uri'
require 'uri'
require 'net/http'
require 'nokogiri'
require 'open_uri_redirections'
include AutoHtml
module LinksHelper

  def video_preview(url)
    if /twitter.com/.match(url)
      url = "https://" + url
    else
      url = 'http://' + url
    end

    auto_html url do
      youtube
      vimeo
      soundcloud
      twitter
    end
  end
  def link_image(data)
    begin  

      if data.xpath('//meta[@property="og:image"]').first
        data.xpath('//meta[@property="og:image"]').first.attribute('content').value
      else
        img_list = data.xpath("/html/body//img[@src[contains(.,'://') and not(contains(.,'ads.') or contains(.,'gif') or contains(.,'ad.') or contains(.,'?'))]][1]") 
        if img_list.css('img')[0]
          result = find_largest_img(img_list.css('img'))
          img_list.css('img')[result].attributes['src'].value if result
        end
      end
    rescue
    end
  end
  def find_largest_img images
    height = 60;
    i = 0;
    large = 0;
    images.each do |image|
      tmp = image.attributes['height'].value.to_i if image.attributes['height']
      if tmp and tmp > height
        height = tmp
        large = i;
      end
      i= i + 1
    end
    if height > 60
      large
    else 
      false
    end
  end
  def check_url
    count = 0
    given =params[:link][:url_link]
    given = "http://" + given if /https?:\/\/[\S]+/.match(given) == nil
    begin       	
      final_url =  open(given, allow_safe_redirections: true).base_uri.to_s
      data = Nokogiri::HTML(open(final_url))
      final_url = final_url.sub(/http:\/\/www.|https:\/\/www.|http:\/\/|https:\/\/|www./, '')
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
        given = given.sub(/http:\/\/www.|https:\/\/www.|http:\/\/|https:\/\/|www./, '')
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

