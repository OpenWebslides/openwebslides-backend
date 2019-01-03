# frozen_string_literal: true

module Assets
  ##
  # Delete an asset in database and filesystem
  #
  class Delete < ApplicationService
    include Helpers::Lockable

    def call(asset, user)
      write_lock asset.topic do
        repo = Repository.new :topic => asset.topic

        # Delete in filesystem
        Repo::Asset::Delete.call repo, asset, user

        # Delete in database
        asset.destroy
      end
    end
  end
end
