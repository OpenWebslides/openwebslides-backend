# frozen_string_literal: true

module Repository
  module Asset
    ##
    # Update an asset in the backing store with a string
    #
    class Update < ApplicationService
      def call(repo, asset, user, content)
        exists = File.exist? Repository::Asset::Find(repo, asset)

        # Copy asset file
        Repository::Asset::Write.call repo, asset, content

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
