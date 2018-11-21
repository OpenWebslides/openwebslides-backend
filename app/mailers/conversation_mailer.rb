# frozen_string_literal: true

class ConversationMailer < ApplicationMailer
  def create(conversation)
    @conversation = conversation

    mail :to => @conversation.topic.user.email,
         :subject => I18n.t('openwebslides.mailer.conversation.create.subject', :title => @conversation.topic.title)
  end
end
