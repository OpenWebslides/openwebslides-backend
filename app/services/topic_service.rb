# frozen_string_literal: true

class TopicService < ApplicationService
  attr_accessor :topic

  def initialize(topic)
    @topic = topic
  end

  ##
  # Update the filesystem contents of a topic
  #
  def update(params)
    # Update database
    updatable_params = params.select do |k|
      TopicResource.updatable_fields.include? k
    end

    if updatable_params.any?
      return false unless @topic.update updatable_params
    end

    return true unless params[:content]

    # Update repository
    command = Repository::Update.new @topic

    command.content = params[:content]
    command.author = params[:author]
    command.message = params[:message]

    command.execute

    # Generate feed item
    FeedItem.create :user => params[:author],
                    :topic => @topic,
                    :event_type => :topic_updated

    true
  rescue OpenWebslides::FormatError => e
    @topic.errors.add :content, e.error_type
    false
  end
end
