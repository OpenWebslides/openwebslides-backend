# frozen_string_literal: true

module Assets
  ##
  # Find an asset in filesystem
  #
  class Find < ApplicationService
    def call(asset)
      # Find in filesystem
      Repository::Asset::Find.new(asset).execute
    end
  end
end
