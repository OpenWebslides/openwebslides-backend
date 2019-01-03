# frozen_string_literal: true

module Repo
  module Asset
    ##
    # Write asset file
    #
    class Write < ApplicationService
      def call(repo, asset, content)
        File.open(Repo::Asset::Find(repo, asset), 'wb') do |f|
          f.write content.read
        end
      end
    end
  end
end
