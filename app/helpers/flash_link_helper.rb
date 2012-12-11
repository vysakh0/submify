module FlashLinkHelper

  def flash_display
    response = ""
    flash.each do |name, msg|
      response = response + content_tag(:div, msg, :id => "flash_#{name}")
    end
    flash.discard
    response
  end
end
