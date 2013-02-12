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
      final_url.slice! "##{URI(final_url).fragment}" if URI(final_url).fragment
      final_url.chomp('/')
      #final_url = final_url[0..-2] if final_url[-1]=='/'
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