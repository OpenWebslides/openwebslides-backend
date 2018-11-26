# frozen_string_literal: true

module Contents
  ##
  # Read the contents of a topic
  #
  class Read < ApplicationService
    def call(topic)
      Repository::Read.call topic
    end
  end
end
