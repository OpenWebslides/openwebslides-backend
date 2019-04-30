# frozen_string_literal: true

class AssetPolicy < ApplicationPolicy
  ##
  # Resource
  #
  def create?
    # Users can create but only for updatable content
    topic_policy.update_content?
  end

  def show?
    # Users can show but only for showable topics
    topic_policy.show?
  end

  def raw?
    # Everyone can view raw assets
    true
  end

  def update?
    # Users can update but only for updatable content
    topic_policy.update_content?
  end

  def destroy?
    # Users can destroy but only for updatable content
    topic_policy.update_content?
  end

  ##
  # Relationship: topic
  #
  def show_topic?
    # Users can show an asset but only for showable topics
    topic_policy.show?
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

  private

  def topic_policy
    @topic_policy ||= Pundit.policy! @user, @record.topic
  end
end
