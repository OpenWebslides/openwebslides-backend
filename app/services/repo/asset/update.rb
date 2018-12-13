# frozen_string_literal: true

module Repo
  module Asset
    ##
    # Update an asset in the backing store with a string
    #
    class Update < ApplicationService
      def call(repo, asset, user, content)
        exists = File.exist? Repo::Asset::Find(repo, asset)

        # Copy asset file
        Repo::Asset::Write.call repo, asset, content

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
