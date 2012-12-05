module ApplicationHelper
def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
end
def tab(value)
  @page_tab = value
end
end
