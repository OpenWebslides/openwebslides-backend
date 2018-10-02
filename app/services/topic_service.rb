# frozen_string_literal: true

class TopicService < ApplicationService
  attr_accessor :topic

  def initialize(topic)
    @topic = topic
  end

  ##
  # Persist a newly built topic to the database and the filesystem
  #
  def create
    # Persist to database
    if @topic.save
      # Persist to file system
      Repository::Create.new(@topic).execute

      # Create feed item
      FeedItem.create :user => @topic.user,
                      :topic => @topic,
                      :event_type => :topic_created

      true
    else
      false
    end
  end

  ##
  # Read the filesystem contents of a topic
  #
  def read
    Repository::Read.new(@topic).execute
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
    command.message = params[:message] if params[:message]

    command.execute

    # Generate feed item
    FeedItem.create :user => params[:author],
                    :topic => @topic,
                    :event_type => :topic_updated

    true
  end

  ##
  # Delete a topic from the database and the filesystem
  #
  def delete
    # Delete repository
    Repository::Delete.new(@topic).execute

    # Delete database
    @topic.destroy
  end

  ##
  # Duplicate (fork) a topic in the database and the filesystem
  #
  # WARNING: @topic contains the _original_ topic in this context
  #
  def fork(params)
    # Duplicate topic
    fork = @topic.dup

    # Set new attributes: author and upstream topic
    fork.user = params[:author]
    fork.upstream = @topic

    # Persist to database
    if fork.save
      # Fork repository in filesystem
      command = Repository::Fork.new @topic

      command.fork = fork

      command.execute

      fork
    else
      false
    end
  end
end
