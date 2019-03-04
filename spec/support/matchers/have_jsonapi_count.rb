# frozen_string_literal: true

module OpenWebslides
  module Matchers
    def have_jsonapi_count(expected)
      HasJSONAPICount.new expected
    end

    class HasJSONAPICount
      include RSpec::Matchers

      def initialize(expected)
        @expected = expected
      end

      def matches?(response)
        actual = JSON.parse(response.body)['data'].count

        @matcher = eq @expected
        @matcher.matches? actual
      end

      def failure_message
        @matcher.failure_message
      end

      def description
        'have JSON API count'
      end
    end
  end
end
