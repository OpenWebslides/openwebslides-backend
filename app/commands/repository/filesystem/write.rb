# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Write content to repository
    #
    class Write < YAMLCommand
      attr_accessor :content

      def execute
        raise OpenWebslides::ArgumentError, 'Content not specified' unless @content

        validate_version
        write_index
        @content.each { |c| write_content_item c }
        cleanup
      end

      private

      ##
      # Write repository index file containing version information and reference to root content item
      #
      def write_index
        root = @content.find { |c| c['type'] == 'contentItemTypes/ROOT' }

        raise OpenWebslides::FormatError, 'No root content item found' unless root

        index_hash = {
          'version' => OpenWebslides.config.repository.version,
          'root' => root['id']
        }

        File.write index_file, index_hash.to_yaml
      end

      ##
      # Write a content item to the repository
      #
      def write_content_item(content_item)
        raise OpenWebslides::FormatError, 'No valid identifier found' unless content_item['id']

        file_path = File.join content_path, "#{content_item['id']}.yml"

        File.write file_path, content_item.to_yaml
      end

      ##
      # Delete orphan content items from the repository
      #
      def cleanup
        # Identifiers in request
        content_item_ids = @content.map { |c| c['id'] }.sort

        # Identifiers in repository
        file_ids = Dir[File.join content_path, '*.yml'].map { |f| File.basename f, '.yml' }.sort

        # Delete orphaned identifiers
        file_ids.each do |id|
          File.rm File.join content_path, "#{id}.yml" unless content_item_ids.include? id
        end
      end
    end
  end
end
