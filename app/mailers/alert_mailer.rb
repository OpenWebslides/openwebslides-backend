# frozen_string_literal: true

class AlertMailer < ApplicationMailer
  def update_topic(alert)
    @alert = alert

    mail :to => alert.user.email,
         :subject => I18n.t('openwebslides.mailer.alert.update_topic.subject', :title => alert.topic.title)
  end

  def submit_pr(alert)
    @alert = alert

    mail :to => alert.user.email,
         :subject => I18n.t('openwebslides.mailer.alert.submit_pr.subject', :title => alert.topic.title)
  end

  def accept_pr(alert)
    @alert = alert

    mail :to => alert.user.email,
         :subject => I18n.t('openwebslides.mailer.alert.accept_pr.subject', :title => alert.topic.title)
  end

  def reject_pr(alert)
    @alert = alert

    mail :to => alert.user.email,
         :subject => I18n.t('openwebslides.mailer.alert.reject_pr.subject', :title => alert.topic.title)
  end

  def fork_topic(alert)
    @alert = alert

    mail :to => alert.user.email,
         :subject => I18n.t('openwebslides.mailer.alert.fork_topic.subject', :title => alert.topic.title)
  end
end
