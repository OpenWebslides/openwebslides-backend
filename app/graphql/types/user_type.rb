# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements Interfaces::Identifyable

    ##
    # Attributes
    #
    field :name,
          String,
          'Full name',
          :null => false

    field :email,
          String,
          'Email address',
          :null => true,
          :authorized => true

    field :gravatar_hash,
          String,
          'Gravatar hash',
          :null => false

    field :locale,
          String,
          'Locale',
          :null => true,
          :authorized => true

    field :alert_emails,
          Boolean,
          'Email alerts enabled',
          :null => true,
          :authorized => true

    ##
    # Relationships
    #
    # field :topics,
    #       [TopicType],
    #       'Authored topics',
    #       :null => false

    # field :collaborations,
    #       [TopicType],
    #       'Collaborated topics',
    #       :null => false

    # field :alerts,
    #       [AlertType],
    #       'Alerts',
    #       :null => false,
    #       :authorized => true

    ##
    # Resolvers
    #
    def gravatar_hash
      Digest::MD5.hexdigest(object.email).downcase
    end
  end
end
