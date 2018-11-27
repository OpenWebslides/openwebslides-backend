# frozen_string_literal: true

module Repository
  module Asset
    ##
    # Copy asset file
    #
    class Copy < ApplicationService
      def call(repo, asset, file)
        FileUtils.cp file, Repository::Asset::Find.call(repo, asset)
      end
    end
  end
end
