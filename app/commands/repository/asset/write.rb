# frozen_string_literal: true

module Repository
  module Asset
    ##
    # Write asset file
    #
    class Write < AssetCommand
      attr_accessor :content

      def execute
        raise OpenWebslides::ArgumentError, 'Content not specified' unless content

        File.open(asset_file, 'wb') do |f|
          f.write content.read
        end
      end
    end
  end
end
