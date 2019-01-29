# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Metadata::UpdatedAt do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  class UpdatedAtTestClass < ApplicationResource
    include Metadata::UpdatedAt
  end

  class UpdatedAtTestOverriddenClass < ApplicationResource
    include Metadata::UpdatedAt

    def meta(options)
      super(options).merge :foo => 'bar'
    end
  end

  class UpdatedAtTestObject
    def updated_at
      Time.now
    end
  end

  ##
  # Test variables
  #
  subject(:updated_at) { UpdatedAtTestClass.new object, context }

  let(:object) { UpdatedAtTestObject.new }
  let(:context) { {} }

  let(:meta_options) { { :serializer => DummySerializer.new } }

  let(:time) { Time.now }

  ##
  # Tests
  #
  it 'adds a :updated_at metadata entry' do
    expect(updated_at.meta meta_options).to include :updated_at
  end

  it 'calls the :updated_at method of the model' do
    expect(object).to receive(:updated_at)

    updated_at.meta meta_options
  end

  it 'formats the time' do
    expect(updated_at.meta(meta_options)[:updated_at]).to eq DateValueFormatter.format(time)
  end

  context 'when there is already a :meta method defined' do
    subject(:updated_at) { UpdatedAtTestOverriddenClass.new object, context }

    it 'merges the :updated_at property into the superclass metadata' do
      expect(updated_at.meta meta_options).to include :updated_at, :foo
    end
  end
end
