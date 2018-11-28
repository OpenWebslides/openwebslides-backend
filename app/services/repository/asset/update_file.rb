# frozen_string_literal: true

module Repository
  module Asset
    ##
    # Update an asset in the backing store with a file
    #
    class UpdateFile < ApplicationService
      def call(repo, asset, user, file)
        exists = File.exist? Repository::Asset::Find.call(repo, asset)

        # Copy asset file
        Repository::Asset::Copy.call repo, asset, file

        # Commit
        # TODO: i18n
        Repository::Git::Commit.call repo, user, "#{exists ? 'Update' : 'Add'} #{asset.filename}"

        # Update timestamps
        asset.touch
        asset.topic.touch
      end
    end
  end
end
