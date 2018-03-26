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

        File.write repo_file, "#{@content.sort.to_h.to_yaml}\n"
      end
    end
  end
end
