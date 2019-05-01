# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentTypeHelper do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  ##
  # Subject
  #
  subject { helper.content_type_for filename }

  ##
  # Tests
  #
  JSONAPI::ALLOWED_BINARY_MEDIA_TYPES.each do |media_type|
    describe "when the media type is #{media_type}" do
      let(:extension) { Mime::Type.lookup(media_type).symbol.to_s }
      let(:filename) { "foo.#{extension}" }

      it { is_expected.to eq media_type }
    end
  end
end
