# frozen_string_literal: true

module Assets
  ##
  # Persist a new asset in database and filesystem
  #
  class Create < ApplicationService
    include Helpers::Lockable

    def call(asset, user, file)
      write_lock asset.topic do
        repo = Repository.new :topic => asset.topic

        if asset.save
          # Persist to filesystem
          Repo::Asset::UpdateFile.call repo, asset, user, file.path
        end
      end

      asset
    end
  end
end
