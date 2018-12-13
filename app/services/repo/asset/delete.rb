# frozen_string_literal: true

module Repo
  module Asset
    ##
    # Write asset file
    #
    class Delete < ApplicationService
      def call(repo, asset, user)
        # Delete asset
        File.delete Repo::Asset::Find.call(repo, asset)

        # Commit
        # TODO: i18n
        Repo::Git::Commit.call repo, user, "Delete #{asset.filename}"

        # Update timestamps
        receiver.touch
        receiver.topic.touch
      end
    end
  end
end
