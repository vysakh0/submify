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
    unless current_user.nil?
      current_user.notifications.where("updated_at > ?", current_user.notify).count  
    else
      0
    end

  end

end
