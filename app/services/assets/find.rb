# frozen_string_literal: true

module Assets
  ##
  # Find an asset in filesystem
  #
  class Find < ApplicationService
    include Helpers::Lockable

    def call(asset)
      read_lock asset.topic do
        repo = Repository.new :topic => asset.topic

        # Find in filesystem
        Repo::Asset::Find.call repo, asset
      end
    end
  end
end
