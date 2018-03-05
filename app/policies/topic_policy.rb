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

  ##
  # Relationship: user
  #
  def show_user?
    # Users can only show user if the topic is showable
    # Authorize the user separately in the controller
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
  # Relationship: notifications
  #
  def show_notifications?
    # Users can only show notifications if the topic is showable
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
