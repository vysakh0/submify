require 'open-uri'
require 'uri'
require 'net/http'
require 'nokogiri'
require 'open_uri_redirections'

module LinksHelper

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
end

