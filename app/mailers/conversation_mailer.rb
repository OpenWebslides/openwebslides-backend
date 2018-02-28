# frozen_string_literal: true

class ConversationMailer < ApplicationMailer
  def create(conversation)
    @conversation = conversation
    @user = conversation.user
    @deck = conversation.deck

    mail :to => @deck.user.email, :subject => I18n.t('openwebslides.mailer.conversation.create.subject')
  end
end
