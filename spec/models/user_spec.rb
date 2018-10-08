# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:user) { create :user, :confirmed }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.not_to allow_values('foo', 'foo@bar@baz', 'foo@', '@bar').for :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of :locale }
    it { is_expected.not_to allow_value('foo').for :locale }
    it { is_expected.to allow_values('en', 'nl').for :locale }
    it { is_expected.to validate_inclusion_of(:locale).in_array I18n.available_locales.map(&:to_s) }
    it { is_expected.to have_attributes :locale => 'en' }

    it { is_expected.to validate_presence_of :password }
    it { is_expected.not_to allow_value('abc12').for :password }
    it { is_expected.to allow_value('abc123').for :password }

    it { is_expected.to validate_presence_of :token_version }
    it { is_expected.to validate_numericality_of(:token_version).only_integer }

    it { is_expected.to validate_presence_of :tos_accepted }
    it { is_expected.not_to allow_values(false, 'false').for :tos_accepted }
    it { is_expected.to allow_values(true, 'foo').for :tos_accepted }

    it { is_expected.to allow_values(false).for :alert_emails }

    context 'when the terms are not accepted' do
      subject { build :user, :tos_accepted => false }

      it { is_expected.not_to be_valid }
    end

    it 'rejects changes to email' do
      expect { user.update! :email => 'bar@foo' }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'invalidates tokens on password change' do
      token_version = user.token_version

      user.update :password => 'abcd1234'
      expect(user.token_version).not_to eq token_version
    end

    it 'defaults to the English locale' do
      expect(User.new.locale).to eq 'en'
    end

    it 'defaults to true for alert_emails' do
      expect(User.new.alert_emails).to be true
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:identities).dependent :destroy }
    it { is_expected.to have_many(:topics).inverse_of(:user).dependent :destroy }
    it { is_expected.to have_many(:grants).dependent :destroy }
    it { is_expected.to have_many(:collaborations).class_name('Topic').through(:grants).source(:topic).inverse_of :collaborators }
    it { is_expected.to have_many(:feed_items).inverse_of(:user).dependent :destroy }
    it { is_expected.to have_many(:annotations).inverse_of(:user).dependent :destroy }
    it { is_expected.to have_many(:ratings).inverse_of(:user).dependent :destroy }

    it 'has an email identity after creating' do
      expect(user.identities.first&.provider).to eq 'email'
    end
  end

  describe 'methods' do
    describe '.find_by_token' do
      context 'when there are no users' do
        it 'returns nil' do
          expect(User.find_by_token :id => 'foo').to eq nil
        end
      end

      context 'when the user is unconfirmed' do
        subject(:user) { create :user }

        it 'raises an UnconfirmedError' do
          expect { User.find_by_token :id => user.id }.to raise_error JSONAPI::Exceptions::UnconfirmedError
        end
      end

      context 'when the user is confirmed' do
        it 'returns the user' do
          expect(User.find_by_token :id => user.id).to eq user
        end
      end
    end
  end
end
