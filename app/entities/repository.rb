# frozen_string_literal: true

##
# Topic repository
#
class Repository < ApplicationEntity
  ##
  # Properties
  #
  ##
  # Associations
  #
  belongs_to :topic

  ##
  # Validations
  #
  ##
  # Callbacks
  #
  ##
  # Methods
  #

  # Root path to repository
  def path(*args)
    File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s, *args
  end

  # Path to repository content
  def content_path
    path 'content'
  end

  # Path to repository assets
  def asset_path
    path 'assets'
  end

  # Path to index file
  def index
    path 'content.yml'
  end

  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
end
