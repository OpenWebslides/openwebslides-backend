# frozen_string_literal: true

module Repo
  module Asset
    ##
    # Update an asset in the backing store with a file
    #
    class UpdateFile < ApplicationService
      def call(repo, asset, user, file)
        exists = File.exist? Repo::Asset::Find.call(repo, asset)

        # Copy asset file
        Repo::Asset::Copy.call repo, asset, file

        # Commit
        # TODO: i18n
        Repo::Git::Commit.call repo, user, "#{exists ? 'Update' : 'Add'} #{asset.filename}"

        # Update timestamps
        asset.touch
        asset.topic.touch
      end
    end
  end
end
