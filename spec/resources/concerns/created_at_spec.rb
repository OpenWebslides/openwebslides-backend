# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreatedAt do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  class CreatedAtTestClass < ApplicationResource
    include CreatedAt
  end

  class CreatedAtTestOverriddenClass < ApplicationResource
    include CreatedAt

    def meta(options)
      super(options).merge :foo => 'bar'
    end
  end

  class CreatedAtTestObject
    def created_at
      Time.now
    end
  end

  ##
  # Test variables
  #
  subject(:created_at) { CreatedAtTestClass.new object, context }

  let(:object) { CreatedAtTestObject.new }
  let(:context) { {} }

  let(:meta_options) { { :serializer => DummySerializer.new } }

  let(:time) { Time.now }

  ##
  # Tests
  #
  it 'adds a :created_at metadata entry' do
    expect(created_at.meta meta_options).to include :created_at
  end

  it 'calls the :created_at method of the model' do
    expect(object).to receive(:created_at)

    created_at.meta meta_options
  end

  it 'formats the time' do
    expect(created_at.meta(meta_options)[:created_at]).to eq DateValueFormatter.format(time)
  end

  context 'when there is already a :meta method defined' do
    subject(:created_at) { CreatedAtTestOverriddenClass.new object, context }

    it 'merges the :created_at property into the superclass metadata' do
      expect(created_at.meta meta_options).to include :created_at, :foo
    end
  end
end
