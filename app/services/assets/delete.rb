# frozen_string_literal: true

module Assets
  ##
  # Delete an asset in database and filesystem
  #
  class Delete < ApplicationService
    include Helpers::Lockable
    include Helpers::Committable

    def call(asset, user)
      write_lock asset.topic do
        repo = repo_for asset.topic

        # Delete in filesystem
        Repository::Asset::Delete.call repo, asset, user

        # Delete in database
        asset.destroy
      end
    end
  end
end
