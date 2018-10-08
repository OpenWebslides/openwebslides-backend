# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy::Scope do
  let(:user) { create :user }

  context 'when resolving all topics' do
    subject { described_class.new(user, Topic).resolve }

    it 'raises an error' do
      expect { subject }.to raise_error OpenWebslides::NotImplementedError
    end
  end

  context 'when resolving all users' do
    subject { described_class.new(user, User).resolve }

    it 'raises an error' do
      expect { subject }.to raise_error OpenWebslides::NotImplementedError
    end
  end
end
