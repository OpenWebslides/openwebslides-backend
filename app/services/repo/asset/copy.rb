# frozen_string_literal: true

module Repo
  module Asset
    ##
    # Copy asset file
    #
    class Copy < ApplicationService
      def call(repo, asset, file)
        FileUtils.cp file, Repo::Asset::Find.call(repo, asset)
      end
    end
  end
end
