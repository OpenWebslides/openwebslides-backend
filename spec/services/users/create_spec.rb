# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Create do
  ##
  # Configuration
  #
  ##
  # Subject
  #
  ##
  # Test variables
  #
  let(:user) { build :user }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the user is valid' do
    before { subject.call user }

    it 'persists the user to the database' do
      expect(user).to be_persisted
    end

    it 'creates a default `email` identity' do
      expect(user.identities.where(:provider => 'email', :uid => user.email)).to be_any
    end
  end

  context 'when the user is invalid' do
    let(:user) { build :user, :email => nil }

    it 'does not persist the user to the database' do
      expect(user).not_to be_persisted

      subject.call user
    end

    describe 'return value' do
      subject { described_class.call user }

      it { is_expected.to be_instance_of User }
      it { is_expected.not_to be_valid }
    end
  end
end
