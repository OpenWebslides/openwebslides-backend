# frozen_string_literal: true

class PullRequestPolicy < ApplicationPolicy
  ##
  # Resource
  #
  def create?
    return false if @user.nil?

    # Users can create a pull request but only for itself
    return false unless @record.user == @user

    # Users can show if the source content is updatable and the target is showable
    source_policy.update_content? && target_policy.show?
  end

  def show?
    return false if @user.nil?

    # Users can show if the source or the target content is updatable
    source_policy.update_content? || target_policy.update_content?
  end

  def update?
    return false if @user.nil?

    # Users can only update if the target content is updatable
    target_policy.update_content?
  end

  ##
  # Relationship: user
  #
  def show_user?
    # Users can only show user if the pull request is showable
    # Authorize the user separately in the controller
    show?
  end

  ##
  # Relationship: source
  #
  def show_source?
    # Users can only show source if the pull request is showable
    # Authorize the source separately in the controller
    show?
  end

  ##
  # Relationship: target
  #
  def show_target?
    # Users can only show target if the pull request is showable
    # Authorize the target separately in the controller
    show?
  end

  ##
  # Scope
  #
  class Scope < Scope
    def resolve
      return scope.none unless @user

      # Users can see pull requests of updatable source and target topics
      source_query = 'source.user_id = ? OR source_grants.user_id = ?'
      target_query = 'target.user_id = ? OR target_grants.user_id = ?'
      query = "#{source_query} OR #{target_query}"

      scope.joins('INNER JOIN topics source ON source.id = pull_requests.source_id')
           .joins('INNER JOIN topics target ON target.id = pull_requests.target_id')
           .joins('LEFT OUTER JOIN grants source_grants ON source_grants.topic_id = source.id')
           .joins('LEFT OUTER JOIN grants target_grants ON target_grants.topic_id = target.id')
           .where(query, @user.id, @user.id, @user.id, @user.id)
           .distinct
    end
  end

  private

  def source_policy
    @source_policy ||= Pundit.policy! @user, @record.source
  end

  def target_policy
    @target_policy ||= Pundit.policy! @user, @record.target
  end
end
