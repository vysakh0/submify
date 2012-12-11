module CommentsHelper

  def timing comment_time
    date = comment_time.to_date

    if Time.now.to_date == date 
      comment_time.strftime("%H:%M")
    else
      date
    end
  end

end
