module ApplicationHelper
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  def tab(value)
    @page_tab = value
  end
  def page_tab
    @page_tab
  end
  #this function allows you to input your account id when you call the function

  def google_analytics_js(id = nil)

    content_tag(:script, :type => 'text/javascript') do
      "var _gaq || [];
      _gaq.push(['_setAccount', '#{id}']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = document.getElementByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();"
    end if !id.blank? && Rails.env.production?
  end
end
