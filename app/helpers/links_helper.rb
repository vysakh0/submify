require 'open-uri'
require 'uri'
require 'net/http'
require 'nokogiri'
require 'open_uri_redirections'

module LinksHelper

  def link_image url
    begin  
      final_url =  open(url, allow_safe_redirections: true).base_uri.to_s
      doc = Nokogiri::HTML(open(final_url))

      if img_list = doc.xpath("/html/body//img[@src[contains(.,'://') and not(contains(.,'ads.') or contains(.,'gif') or contains(.,'ad.') or contains(.,'?'))]][1]") 
        if img_list.css('img')[0]
          result = find_largest_img(img_list.css('img'))
          first_img =  img_list.css('img')[result].attributes['src'].value
          image_tag(first_img, size: "50x75")
        end
      end
    rescue URI::InvalidURIError
      doc = Net::HTTP.get host, path
      data = Nokogiri::HTML(doc)	
      if img_list= data.xpath("/html/body//img[@src[contains(.,'://') and not(contains(.,'ads.') or contains(.,'ad.') or contains(.,'?'))]][1]") 
        if img_list.css('img')[0]
          result = find_largest_img(img_list.css('img'))
          first_img =  img_list.css('img')[result].attributes['src'].value
          image_tag(first_img, size: "50x75")
        end
      end
    rescue
    end
  end
  def find_largest_img images
    height = 0;
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
    large
  end
end

