# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Render the HTML
    #
    class Write < RepoCommand
      attr_accessor :content

      def execute
        raise OpenWebslides::ArgumentError, 'Content not specified' unless @content

        File.write repo_file, "#{JSON.pretty_generate(@content)}\n"
      end
    end
  end
end
