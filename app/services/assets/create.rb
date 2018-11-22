# frozen_string_literal: true

module Assets
  ##
  # Persist a new asset in database and filesystem
  #
  class Create < ApplicationService
    def call(asset, user, file)
      if asset.save
        # Persist to filesystem
        command = Repository::Asset::UpdateFile.new asset

        command.author = user
        command.file = file.path

        command.execute
      end

      asset
    end
  end
end
