module CommentsHelper

  def timing comment_time

    if Time.now.to_date == comment_time.to_date
      comment_time.strftime("%H:%M")
    else
      comment_time.strftime("%d-%m-%y")
    end
  end

end
