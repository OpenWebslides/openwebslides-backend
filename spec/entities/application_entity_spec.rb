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
    property :my_property
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
    describe '.property' do
      describe 'adds a property' do
        it { is_expected.to respond_to :my_property }
        it { is_expected.to respond_to :my_property= }
      end
    end

    describe '.belongs_to' do
      describe 'adds a property and validates presence' do
        it { is_expected.to respond_to :my_association }
        it { is_expected.to respond_to :my_association= }
        it { is_expected.to validate_presence_of :my_association }
      end
    end
  end
end
