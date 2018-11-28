# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy::Scope do
  ##
  # Configuration
  #
  include_context 'policy_sample'

  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:scope) { described_class.new(user, Comment).resolve.count }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it 'inherits AnnotationPolicy' do
    expect(described_class).to be < AnnotationPolicy::Scope
  end
end
