# frozen_string_literal: true

module Assets
  ##
  # Persist a new asset in database and filesystem
  #
  class Create < ApplicationService
    include Helpers::Lockable
    include Helpers::Committable

    def call(asset, user, file)
      write_lock asset.topic do
        repo = repo_for asset.topic

        if asset.save
          # Persist to filesystem
          Repo::Asset::UpdateFile.call repo, asset, user, file.path
        end
      end

      asset
    end
  end
end
