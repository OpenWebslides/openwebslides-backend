# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Read contents of local repository
    #
    class Read < RepoCommand
      def execute
        doc = Nokogiri::HTML5 File.read(repo_file)
        doc.at('body').children
      end
    end
  end
end
