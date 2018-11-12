# frozen_string_literal: true

class TopicPolicy < ApplicationPolicy
  ##
  # Resource
  #
  def index?
    # Everyone can list topics
    true
  end

  def create?
    return false if @user.nil?

    # Users can create a topic but only for itself
    @record.user == @user
  end

  def show?
    # Users can show public topics, collaborations and owned topics
    if @record.public_access?
      # Users and guests can show
      true
    elsif @record.protected_access?
      # Users can show protected topic
      !@user.nil?
    elsif @record.private_access?
      return false if @user.nil?

      # Owner and collaborators can read private topic
      @record.user == @user || @record.collaborators.include?(@user)
    end
  end

  def update?
    return false if @user.nil?

    # Owner and collaborators can update topic
    @record.user == @user || @record.collaborators.include?(@user)
  end

  def destroy?
    return false if @user.nil?

    # Owner can destroy topic
    @record.user == @user
  end

  def fork?
    return false if @user.nil?

    # User can only fork if the topic is showable
    show?
  end

  ##
  # Relationship: user
  #
  def show_user?
    # Users can only show user if the topic is showable
    # Authorize the user separately in the controller
    show?
  end

  ##
  # Relationship: upstream
  #
  def show_upstream?
    # Users can only show upstream if the topic is showable
    # Authorize the topic separately in the controller
    show?
  end

  ##
  # Relationship: forks
  #
  def show_forks?
    # Users can only show forks if the topic is showable
    # Policy scope separately in the controller
    show?
  end

  ##
  # Relationship: collaborators
  #
  def show_collaborators?
    # Users can only show collaborators if the topic is showable
    # Policy scope separately in the controller
    show?
  end

  ##
  # Relationship: feed items
  #
  def show_feed_items?
    # Users can only show feed items if the topic is showable
    # Policy scope separately in the controller
    show?
  end

  ##
  # Relationship: assets
  #
  def show_assets?
    # Users can only show assets if the topic is showable
    # Policy scope separately in the controller
    show?
  end

  ##
  # Relationship: conversations
  #
  def show_conversations?
    # Users can only show conversations if the topic is showable
    # Policy scope separately in the controller
    show?
  end

  ##
  # Relationships: annotations
  #
  def show_annotations?
    # Users can show annotations relationship if the topic is showable
    # Policy scope the annotations separately in the controller
    show?
  end

  ##
  # Relationships: incoming_pull_requests
  #
  def show_incoming_pull_requests?
    # Users can show incoming pull requests relationship if the topic is updatable
    # Policy scope the pull requests separately in the controller
    update?
  end

  ##
  # Relationships: outgoing_pull_requests
  #
  def show_outgoing_pull_requests?
    # Users can show outgoing pull requests relationship if the topic is updatable
    # Policy scope the pull requests separately in the controller
    update?
  end

  ##
  # Scope
  #
  class Scope < Scope
    def resolve
      if @user
        # Users can see public topics, protected topics and collaborations
        query = 'topics.state != ? OR topics.user_id = ? OR access_grants.user_id = ?'

        scope.joins('LEFT OUTER JOIN grants access_grants ON access_grants.topic_id = topics.id')
             .where(query, Topic.states['private_access'], @user.id, @user.id)
             .distinct
      else
        # Everyone can see public topics
        scope.where('topics.state' => 'public_access')
      end
    end
  end
end
