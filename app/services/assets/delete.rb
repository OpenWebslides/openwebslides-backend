# frozen_string_literal: true

module Assets
  ##
  # Delete an asset in database and filesystem
  #
  class Delete < ApplicationService
    def call(asset, user)
      # Delete in filesystem
      command = Repository::Asset::Destroy.new asset

      command.author = user

      command.execute

      # Delete in database
      asset.destroy
    end
  end
end
