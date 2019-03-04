# frozen_string_literal: true

module OpenWebslides
  module Matchers
    def have_jsonapi_relationships(expected)
      HasJSONAPIrelationships.new expected
    end

    class HasJSONAPIrelationships
      include RSpec::Matchers

      def initialize(expected)
        @expected = expected
      end

      def matches?(response)
        actual = Hash[JSON.parse(response.body)['data']['relationships']
                          .map { |r, v| [r, v&.dig('data', 'id')] }]
                 .with_indifferent_access

        @matcher = include @expected
        @matcher.matches? actual
      end

      def failure_message
        @matcher.failure_message
      end

      def description
        'have JSON API relationships'
      end
    end
  end
end
