# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Write content to repository
    #
    class Write < YAMLCommand
      attr_accessor :content

      def execute
        raise OpenWebslides::ArgumentError, 'Content not specified' unless content

        # Ensure repository data format version is compatible
        validate_version

        # Find root content item
        root = content.find { |c| c['type'] == 'contentItemTypes/ROOT' }
        raise OpenWebslides::Content::NoRootContentItemError unless root

        # Ensure root content item is the same as the database version
        raise OpenWebslides::Content::InvalidRootContentItemError unless root['id'] == receiver.root_content_item_id

        # Write index file including root content item identifier
        write_index 'root' => root['id']

        # Write content item files
        content.each { |c| write_content_item c }

        # Delete orphaned content item files
        cleanup_content
      end

      private

      ##
      # Write a content item to the repository
      #
      def write_content_item(content_item)
        raise OpenWebslides::Content::ContentError unless content_item['id']

        file_path = File.join content_path, "#{content_item['id']}.yml"

        File.write file_path, content_item.to_yaml
      end

      ##
      # Delete orphan content items from the repository
      #
      def cleanup_content
        # Identifiers in request
        content_item_ids = content.map { |c| c['id'] }.sort

        # Identifiers in repository
        file_ids = Dir[File.join content_path, '*.yml'].map { |f| File.basename f, '.yml' }.sort

        # Delete orphaned identifiers
        file_ids.each do |id|
          FileUtils.rm File.join content_path, "#{id}.yml" unless content_item_ids.include? id
        end
      end
    end
  end
end
