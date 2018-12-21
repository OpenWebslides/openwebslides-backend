# frozen_string_literal: true

##
# Abstract worker
#
class ApplicationWorker
  include Sidekiq::Worker

  def perform(*args); end
end
