module UsersHelper

  def render_users(users)
    if user.to_a.size > 0
      render(users)
    else
      content_tag(:div, "No users were found", class: 'msg')
    end
  end


  def gravatar_for(user)

    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar" )

  end

  def gravatar_for(user, options = { size: 50})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"

    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end
