# frozen_string_literal: true

module Users
  ##
  # Persist a new user in database
  #
  class Create < ApplicationService
    def call(user)
      # Create a default 'email' identity
      user.identities.build :provider => 'email', :uid => user.email

      user.save

      user
    end
  end
end
