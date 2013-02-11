module CommentsHelper

  def timing time
    date = time.to_date

    if Time.now.to_date == date 
      time.strftime("%H:%M")
    else
      date
    end
  end

  def link_user_comment link, user
    link.comments.where(user_id: user).first
  end

end
