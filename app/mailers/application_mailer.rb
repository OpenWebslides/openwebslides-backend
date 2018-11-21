# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  add_template_helper WebUrlHelper

  default :from => Rails.application.config.devise.mailer_sender

  layout 'mailer'
end
