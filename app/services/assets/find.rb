# frozen_string_literal: true

module Assets
  ##
  # Find an asset in filesystem
  #
  class Find < ApplicationService
    include Helpers::Lockable
    include Helpers::Committable

    def call(asset)
      read_lock asset.topic do
        repo = repo_for asset.topic

        # Find in filesystem
        Repository::Asset::Find.call repo, asset
      end
    end
  end
end
