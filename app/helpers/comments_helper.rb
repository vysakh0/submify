module CommentsHelper

  def timing time
    date = time.to_date

    if Time.now.to_date == date 
      time.strftime("%H:%M")
    else
      date
    end
  end

end
