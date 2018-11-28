# frozen_string_literal: true

module Repository
  module Asset
    ##
    # Write asset file
    #
    class Delete < ApplicationService
      def call(repo, asset, user)
        # Delete asset
        File.delete Repository::Asset::Find.call(repo, asset)

        # Commit
        # TODO: i18n
        Repository::Git::Commit.call repo, user, "Delete #{asset.filename}"

        # Update timestamps
        receiver.touch
        receiver.topic.touch
      end
    end
  end
end
