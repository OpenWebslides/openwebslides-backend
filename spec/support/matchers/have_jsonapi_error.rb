# frozen_string_literal: true

module OpenWebslides
  module Matchers
    def have_jsonapi_error(expected)
      HasJSONAPIError.new expected
    end

    class HasJSONAPIError
      include RSpec::Matchers

      def initialize(expected)
        @expected = expected
      end

      def matches?(response)
        errors = JSON.parse(response.body)['errors']
        if errors.one?
          # Only one error, check for equality
          actual = errors.first['code']
          @matcher = eq @expected
        else
          # Array of errors, check for inclusion
          actual = errors.map { |e| e['code'] }
          @matcher = include @expected
        end

        @matcher.matches? actual
      end

      def failure_message
        @matcher.failure_message
      end

      def description
        'have JSON API error code'
      end
    end
  end
end
