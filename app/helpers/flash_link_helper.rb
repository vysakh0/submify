module FlashLinkHelper

  def flash_display
    response = ""
    flash.each do |key, value| 
      response = response + content_tag(:div, value, class: "alert alert-#{key}")
      
    end
    flash.discard
    response
  end

  def notify_count
    current_user.notifications.where("created_at > ?", current_user.notify).count  
  end

end
