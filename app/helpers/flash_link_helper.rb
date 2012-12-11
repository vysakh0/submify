module FlashLinkHelper

  def flash_display
    response = ""
    flash.each do |key, value| 
      response = response + content_tag(:div, value, class: "alert alert-#{key}")
      
    end
    flash.discard
    response
  end
end
