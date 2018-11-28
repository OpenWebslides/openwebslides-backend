# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationRecord, :type => :model do
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
  # Tests
  #
  describe 'methods' do
    describe '.attribute' do
      it 'does nothing if it is called' do
        expect { described_class.attribute :my_attribute }.not_to raise_error
      end
    end
  end
end
