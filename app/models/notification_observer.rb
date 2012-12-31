class NotificationObserver < ActiveRecord::Observer
  observe :vote, :comment, :relationship

  def after_create(notifiable)
    if notifiable.is_a? Comment
      if notifiable.commentable.is_a? Comment
        Notification.create!(notifiable_id: notifiable.commentable.id, notifiable_type: "Comment", user_id: notifiable.commentable.user_id)
      end
    elsif notifiable.is_a? Vote
      Notification.create!(notifiable_id: notifiable.votable.id, notifiable_type: notifiable.votable.class.name, user_id: notifiable.votable.user_id)
    elsif notifiable.is_a? Relationship

      Notification.create!(notifiable_id: notifiable.id, notifiable_type: "Relationship", user_id: notifiable.followed_id)
    end
  end
end
