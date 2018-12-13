# frozen_string_literal: true

module Repo
  module Asset
    ##
    # Find an asset in the repository
    #
    class Find < ApplicationService
      def call(repo, asset)
        File.join repo.asset_path, asset.filename
      end
    end
  end
end
