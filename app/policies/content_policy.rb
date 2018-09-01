# frozen_string_literal: true

class ContentPolicy < ApplicationPolicy
  ##
  # Resource
  #
  def show?
    # Users who can show the topic can show
    topic_policy.show?
  end

  def update?
    return false if @user.nil?

    # Owner and collaborators can update topic
    @record.topic.user == @user || @record.topic.collaborators.include?(@user)
  end

  ##
  # Relationship: topic
  #
  def show_topic?
    # Users can show an asset but only for showable topics
    topic_policy.show?
  end

  def topic_policy
    @topic_policy ||= Pundit.policy! @user, @record.topic
  end
end
