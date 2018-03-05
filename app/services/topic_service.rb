# frozen_string_literal: true

class TopicService < ApplicationService
  attr_accessor :topic

  def initialize(topic)
    @topic = topic
  end

  def create
    if @topic.save
      Repository::Create.new(@topic).execute
      Notification.create :user => @topic.user,
                          :topic => @topic,
                          :event_type => :topic_created

      true
    else
      false
    end
  end

  def read
    Repository::Read.new(@topic).execute
  end

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
    command.message = params[:message] if params[:message]

    command.execute

    # Generate notification
    Notification.create :user => params[:author],
                        :topic => @topic,
                        :event_type => :topic_updated

    true
  end

  def delete
    # Delete repository
    Repository::Delete.new(@topic).execute

    # Delete database
    @topic.destroy
  end

  def import(repository)
    if @topic.save
      command = Repository::Import.new @topic

      command.repository = repository

      command.execute

      Notification.create :user => @topic.user,
                          :topic => @topic,
                          :event_type => :topic_created

      true
    else
      false
    end
  rescue => e
    delete
    raise e
  end
end
