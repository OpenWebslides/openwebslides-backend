# frozen_string_literal: true

class CommentMailer < ApplicationMailer
  def create(comment)
    @comment = comment

    mail :to => @comment.conversation.user.email,
         :subject => I18n.t('openwebslides.mailer.comment.create.subject', :title => @comment.topic.title)
  end
end
