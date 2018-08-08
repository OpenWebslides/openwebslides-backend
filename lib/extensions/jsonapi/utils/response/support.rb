# frozen_string_literal: true

module Extensions
  module JSONAPI
    module Utils
      module Response
        module Support
          private

          def correct_media_type
            return if response.body.empty?

            ct = "#{::JSONAPI::MEDIA_TYPE}, #{OpenWebslides::MEDIA_TYPE}; version=#{OpenWebslides.config.api.version}"
            response.headers['Content-Type'] = ct
          end
        end
      end
    end
  end
end

JSONAPI::Utils::Response.include Extensions::JSONAPI::Utils::Response::Support
