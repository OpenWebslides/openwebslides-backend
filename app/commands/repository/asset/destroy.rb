# frozen_string_literal: true

module Repository
  module Asset
    ##
    # Write asset file
    #
    class Destroy < AssetCommand
      attr_accessor :author

      def execute
        raise OpenWebslides::ArgumentError, 'No author specified' unless @author

        File.delete asset_file

        # Commit
        exec_topic Git::Commit do |c|
          c.author = @author
          c.message = "Delete #{@receiver.filename}"
        end

        # Update timestamps
        @receiver.touch
        @receiver.topic.touch
      end
    end
  end
end
