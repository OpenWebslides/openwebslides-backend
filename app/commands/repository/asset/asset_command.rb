# frozen_string_literal: true

module Repository
  module Asset
    ##
    # Asset command
    #
    class AssetCommand < RepoCommand
      protected

      def repo_path
        File.join OpenWebslides.config.repository.path, @receiver.topic.user.id.to_s, @receiver.topic.id.to_s
      end

      def asset_path
        File.join repo_path, 'assets'
      end

      def asset_file
        File.join asset_path, @receiver.filename
      end

      ##
      # Execute an action (internal helper)
      #
      def exec_topic(klass)
        command = klass.new @receiver.topic
        yield command if block_given?

        command.execute
      end
    end
  end
end
