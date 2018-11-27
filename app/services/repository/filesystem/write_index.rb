# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Write index file to repository
    #
    class WriteIndex < ApplicationService
      def call(repo, attrs = {})
        # Add data format version to index file
        hash = { 'version' => OpenWebslides.config.repository.version }.merge attrs

        File.write repo.index, hash.to_yaml
      end
    end
  end
end
