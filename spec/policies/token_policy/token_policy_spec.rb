# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenPolicy do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:policy) { described_class.new user, nil }

  ##
  # Test variables
  #
  let(:user) { create :user }
  ##
  # Tests
  #

  it { is_expected.to permit_action :create }
  it { is_expected.to permit_action :update }
  it { is_expected.to permit_action :destroy }

  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to permit_action :create }
    it { is_expected.to forbid_action :update }
    it { is_expected.to forbid_action :destroy }
  end
end
