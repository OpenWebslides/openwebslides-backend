# frozen_string_literal: true

class AnnotationPolicy < ApplicationPolicy
  ##
  # Resource
  #
  def create?
    return false if @user.nil?
    return false if @record.topic.nil?
    return false if @record.user.nil?

    # Users can create but only for showable topic and updatable user
    topic_policy.show? && user_policy.update?
  end

  def show?
    # Users can show but only for showable topic
    topic_policy.show? && user_policy.show?
  end

  def update?
    return false if @user.nil?
    return false if @record.topic.nil?
    return false if @record.user.nil?

    # Users can update but only for showable topic and updatable user
    topic_policy.show? && user_policy.update?
  end

  def destroy?
    return false if @user.nil?

    # Users can destroy but only for showable topic and updatable user
    topic_policy.show? && user_policy.update?
  end

  def flag?
    return false if @user.nil?

    # Users can flag but only for updatable content
    topic_policy.update_content?
  end

  ##
  # Relationship: user
  #
  def show_user?
    return false if @record.user.nil?

    # Users can show user but only for showable user
    user_policy.show?
  end

  ##
  # Relationship: topic
  #
  def show_topic?
    return false if @record.user.nil?

    # Users can show user but only for showable topic
    topic_policy.show?
  end

  ##
  # Scope
  #
  class Scope < Scope
    def resolve
      # Defer annotation scoping to the respective topics
      TopicPolicy::Scope.new(@user, scope.joins(:topic)).resolve
    end
  end

  private

  def topic_policy
    @topic_policy ||= Pundit.policy! @user, @record.topic
  end

  def user_policy
    @user_policy ||= Pundit.policy! @user, @record.user
  end
end
