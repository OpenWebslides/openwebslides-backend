# frozen_string_literal: true

class ConversationMailer < ApplicationMailer
  def create(conversation)
    @conversation = conversation
    @user = conversation.user
    @topic = conversation.topic

    mail :to => @topic.user.email, :subject => I18n.t('openwebslides.mailer.conversation.create.subject')
  end
end
