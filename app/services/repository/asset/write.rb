# frozen_string_literal: true

module Repository
  module Asset
    ##
    # Write asset file
    #
    class Write < ApplicationService
      def call(repo, asset, content)
        File.open(Repository::Asset::Find(repo, asset), 'wb') do |f|
          f.write content.read
        end
      end
    end
  end
end
