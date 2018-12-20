# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Metadata::CommentCount do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  class CommentCountTestClass < ApplicationResource
    include Metadata::CommentCount
  end

  class CommentCountTestOverriddenClass < ApplicationResource
    include Metadata::CommentCount

    def meta(options)
      super(options).merge :foo => 'bar'
    end
  end

  class CommentCountTestObject
    def comments
      %w[1 2 3]
    end
  end

  ##
  # Test variables
  #
  subject(:comment_count) { CommentCountTestClass.new object, context }

  let(:object) { CommentCountTestObject.new }
  let(:context) { {} }

  let(:meta_options) { { :serializer => DummySerializer.new } }

  let(:time) { Time.now }

  ##
  # Tests
  #
  it 'adds a :comment_count metadata entry' do
    expect(comment_count.meta meta_options).to include :comment_count
  end

  it 'calls the :comment_count method of the model' do
    expect(object).to receive(:comments).and_return %w[1 2 3]

    comment_count.meta meta_options
  end

  it 'returns the number of comments' do
    expect(comment_count.meta(meta_options)[:comment_count]).to eq 3
  end

  context 'when there is already a :meta method defined' do
    subject(:comment_count) { CommentCountTestOverriddenClass.new object, context }

    it 'merges the :comment_count property into the superclass metadata' do
      expect(comment_count.meta meta_options).to include :comment_count, :foo
    end
  end
end
