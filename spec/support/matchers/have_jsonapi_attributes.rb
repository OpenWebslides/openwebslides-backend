# frozen_string_literal: true

module OpenWebslides
  module Matchers
    def have_jsonapi_attributes(expected)
      HasJSONAPIAttributes.new expected
    end

    class HasJSONAPIAttributes
      include RSpec::Matchers

      def initialize(expected)
        @expected = expected
      end

      def matches?(response)
        actual = JSON.parse(response.body)['data']['attributes']
                     .with_indifferent_access

        @matcher = include @expected
        @matcher.matches? actual
      end

      def failure_message
        @matcher.failure_message
      end

      def description
        'have JSON API attributes'
      end
    end
  end
end
