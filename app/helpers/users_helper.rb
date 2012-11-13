module UsersHelper

  def render_users(users)
    if user.to_a.size > 0
      render(users)
    else
      content_tag(:div, "No users were found", class: 'msg')
    end
  end


  def gravatar_for(user)

    gravatar_url = "https://graph.facebook.com/#{user.uid}/picture"
    image_tag(gravatar_url, alt: user.name, class: "gravatar" )

  end

  def gravatar_for(user, options = { size: 50})
    size = options[:size]
    gravatar_url = "https://graph.facebook.com/#{user.uid}/picture?width=#{size}&height=#{size}"

    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end
