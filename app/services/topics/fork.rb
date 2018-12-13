# frozen_string_literal: true

module Topics
  ##
  # Fork (duplicate) a topic in database and filesystem
  #
  class Fork < ApplicationService
    def call(topic, user)
      fork_params = topic.slice :title,
                                :description,
                                :access,
                                :root_content_item_id

      fork = Topic.new fork_params

      # Set upstream topic, new owner and title
      fork.upstream = topic
      fork.user = user
      fork.title = I18n.t('openwebslides.topics.forked', :title => topic.title)

      # Duplicate assets
      topic.assets.each do |asset|
        fork.assets << Asset.new(:filename => asset.filename)
      end

      Topics::ForkWorker.perform_async topic.id, fork.id if fork.save

      # return AR record
      fork
    end
  end
end
