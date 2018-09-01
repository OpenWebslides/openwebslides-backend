# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationEntity, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  class TestEntity < ApplicationEntity
    property :my_attribute
    belongs_to :my_association
  end

  ##
  # Subject
  #
  subject { TestEntity.new }

  ##
  # Tests
  #
  describe 'methods' do
    describe '#initialize' do
      it 'assigns attributes' do
        test_entity = TestEntity.new :my_attribute => 'foobar'

        expect(test_entity.my_attribute).to eq 'foobar'
      end

      it 'raises UnknownAttributeError on uknown attribute' do
        expect { TestEntity.new :foo => 'bar' }.to raise_error ActiveModel::UnknownAttributeError
      end
    end

    describe '.attribute' do
      describe 'adds a attribute' do
        it { is_expected.to respond_to :my_attribute }
        it { is_expected.to respond_to :my_attribute= }
      end
    end

    describe '.belongs_to' do
      describe 'adds a attribute and validates presence' do
        it { is_expected.to respond_to :my_association }
        it { is_expected.to respond_to :my_association= }
        it { is_expected.to validate_presence_of :my_association }
      end
    end
  end
end
