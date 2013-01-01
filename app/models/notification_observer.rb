class NotificationObserver < ActiveRecord::Observer
  observe :vote, :comment, :relationship

  def after_create(notifiable)
    if notifiable.is_a? Comment
      if notifiable.commentable.is_a? Comment
        Notification.create!(notifiable_id: notifiable.id, notifiable_type: notifiable.class.name, user_id: notifiable.user_to_notify)
      end
    else
      Notification.create!(notifiable_id: notifiable.id, notifiable_type: notifiable.class.name, user_id: notifiable.user_to_notify)
    end
  end
end
