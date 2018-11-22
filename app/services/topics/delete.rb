# frozen_string_literal: true

module Topics
  ##
  # Delete a topic in database and filesystem
  #
  class Delete < ApplicationService
    def call(topic)
      # Delete in filesystem
      Repository::Delete.new(topic).execute

      # Delete in database
      topic.destroy
    end
  end
end
