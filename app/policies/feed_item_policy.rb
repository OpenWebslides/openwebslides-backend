# frozen_string_literal: true

class FeedItemPolicy < ApplicationPolicy
  ##
  # Resource
  #
  def index?
    # Everyone can list feed items
    true
  end

  def show?
    # Users can show feed items if the topic and the user are showable
    Pundit.policy!(@user, @record.topic).show? && Pundit.policy!(@user, @record.user).show?
  end

  ##
  # Relationship: user
  #
  def show_user?
    # Users can only show user relationship if the feed item is showable
    # Authorize the user separately in the controller
    show?
  end

  ##
  # Relationship: topic
  #
  def show_topic?
    # Users can only show topic relationship if the feed item is showable
    # Authorize the topic separately in the controller
    show?
  end

  ##
  # Scope
  #
  class Scope < Scope
    def resolve
      # Defer asset scoping to the respective topics
      TopicPolicy::Scope.new(@user, scope.joins(:topic)).resolve
    end
  end
end
