# frozen_string_literal: true

module Types
  class AlertType < Types::BaseObject
    implements Interfaces::Identifyable
    implements Interfaces::Creatable

    ##
    # Attributes
    #
    field :read,
          Boolean,
          'Read status',
          :null => false

    field :alert_type,
          Enums::AlertTypeEnum,
          'Alert type',
          :null => false

    field :count,
          Integer,
          'Update count',
          :null => true

    ##
    # Relationships
    #
    field :user,
          UserType,
          'User that generated the alert',
          :null => false

    # field :topic,
    #       TopicType,
    #       'Topic referenced in the alert',
    #       :null => true

    # field :pull_request,
    #       PullRequestType,
    #       'Pull request referenced in the alert',
    #       :null => true

    field :subject,
          UserType,
          'User referenced in the alert',
          :null => true

    ##
    # Resolvers
    #
  end
end
