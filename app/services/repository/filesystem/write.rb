# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Write content to repository
    #
    class Write < ApplicationService
      attr_accessor :repo

      def call(repo, content)
        @repo = repo

        # Ensure repository data format version is compatible
        repo.validate_version!

        # Find root content item
        root = content.find { |c| c['type'] == 'contentItemTypes/ROOT' }
        raise OpenWebslides::Content::NoRootContentItemError unless root

        # Ensure root content item is equal to the database
        raise OpenWebslides::Content::InvalidRootContentItemError unless root['id'] == repo.topic.root_content_item_id

        # Write index file including root content item identifier
        Repository::Filesystem::WriteIndex.call repo, 'root' => root['id']

        # Write content item files
        content.each { |content_item| write_content_item content_item }

        cleanup_content content
      end

      # Write content item
      def write_content_item(content_item)
        raise OpenWebslides::Content::InvalidContentItemError unless content_item['id']

        file_path = File.join repo.content_path, "#{content_item['id']}.yml"

        File.write file_path, content_item.to_yaml
      end

      # Delete orphaned content items
      def cleanup_content(content)
        # Identifiers in request
        content_item_ids = content.map { |c| c['id'] }.sort

        # Identifiers in repository
        file_ids = Dir[File.join repo.content_path, '*.yml'].map { |f| File.basename f, '.yml' }.sort

        # Delete orphaned identifiers
        file_ids.each do |id|
          FileUtils.rm File.join repo.content_path, "#{id}.yml" unless content_item_ids.include? id
        end
      end
    end
  end
end
