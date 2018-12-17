# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Oauth::OmniauthCallbacksController do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:user) { create :user, :with_identities }
  let(:auth_hash) { {} }

  ##
  # Test subject
  #
  subject { described_class.new }

  ##
  # Mocks and stubs
  #
  #
  ##
  # Tests
  #
  describe '#failure' do
    it 'redirects with an error parameter' do
      allow(subject).to receive(:failure_message)
        .and_return 'foobarMessage'

      expect(subject).to receive(:redirect_to)
        .with '/auth/sso?error=foobarMessage'

      subject.failure
    end
  end

  describe 'providers' do
    it 'has a facebook callback method' do
      expect(subject).to receive(:callback)

      subject.facebook
    end

    it 'has a google_oauth2 callback method' do
      expect(subject).to receive(:callback)

      subject.google_oauth2
    end

    it 'has a cas callback method' do
      expect(subject).to receive(:callback)

      subject.cas
    end
  end

  describe '#callback' do
    before do
      subject.instance_variable_set :@resource, user

      allow(subject).to receive :retrieve_identity
      allow(subject).to receive :sync_information
    end

    it 'saves the resource and redirects with a token and a user id' do
      expect(subject.instance_variable_get :@resource).to receive :save!

      expect(subject).to receive(:redirect_to)
        .with %r{/auth/sso\?apiToken=.*&userId=.*}

      subject.callback
    end

    it 'redirects with an error when the resource fails to save' do
      allow(subject.instance_variable_get :@resource).to receive(:save!)
        .and_raise ActiveRecord::RecordInvalid

      expect(subject).to receive(:redirect_to)
        .with '/auth/sso?error=Record+invalid'

      subject.callback
    end
  end

  describe '#retrieve_identity' do
    before do
      subject.instance_variable_set :@resource, user
      subject.instance_variable_set :@identity, user.identities.first
    end

    it 'raises when no email' do
      allow(subject).to receive(:email)
        .and_return nil

      expect { subject.send :retrieve_identity }.to raise_error ArgumentError
    end

    it 'calls find_or_create_user and find_or_create_identity' do
      allow(subject).to receive(:email)
        .and_return 'foo@bar'

      expect(subject).to receive(:find_or_create_user)
      expect(subject).to receive(:find_or_create_identity)

      subject.send :retrieve_identity
    end
  end

  describe '#find_or_create_user' do
    describe 'existing user' do
      it 'sets the @resource instance variable' do
        allow(subject).to receive(:email).and_return user.email

        expect { subject.send :find_or_create_user }.not_to raise_error
        expect(subject.instance_variable_get :@resource).to eq user
      end
    end

    describe 'new user' do
      let(:auth_hash) { { 'info' => { 'email' => 'foo@bar', 'name' => 'Foo Bar' } } }

      before { allow(subject).to receive(:auth_hash).and_return auth_hash }

      it 'creates a new user, setting attributes and skipping the confirmation process' do
        user_stub = double 'User'
        allow(User).to receive(:new).and_return user_stub
        allow(user_stub).to receive(:email).and_return 'foo@bar'

        expect(user_stub).to receive(:name=)
        expect(user_stub).to receive(:password=)
        expect(user_stub).to receive(:password_confirmation=)
        expect(user_stub).to receive(:skip_confirmation!)
        expect(user_stub).to receive(:save!)

        expect { subject.send :find_or_create_user }.not_to raise_error
      end
    end
  end

  describe '#find_or_create_identity' do
    before do
      subject.instance_variable_set :@resource, user

      allow(subject).to receive(:auth_hash).and_return auth_hash
    end

    describe 'existing identity' do
      let(:auth_hash) { { 'uid' => user.identities.first.uid, 'provider' => user.identities.first.provider } }

      it 'sets the @identity instance variable' do
        expect { subject.send :find_or_create_identity }.not_to raise_error
        expect(subject.instance_variable_get :@identity).to eq user.identities.first
      end
    end

    describe 'new identity' do
      let(:auth_hash) { { 'uid' => 'fooUid', 'provider' => 'fooProvider' } }

      it 'creates a new identity' do
        expect { subject.send :find_or_create_identity }.not_to raise_error
        expect(user.identities.last.uid).to eq 'fooUid'
        expect(user.identities.last.provider).to eq 'fooProvider'
      end
    end
  end

  describe '#set_random_password' do
    before { subject.instance_variable_set :@resource, user }

    it 'sets @password and @password_confirmation on the resource to some non-nil value' do
      expect(subject.instance_variable_get :@resource).to receive(:password=)
        .with String

      expect(subject.instance_variable_get :@resource).to receive(:password_confirmation=)
        .with String

      subject.send :set_random_password
    end
  end

  describe '#sync_information' do
    before { subject.instance_variable_set :@resource, user }

    it 'sets @name on the resource' do
      allow(subject).to receive(:first_name).and_return 'Foo'
      allow(subject).to receive(:last_name).and_return 'Bar'

      expect(subject.instance_variable_get :@resource).to receive(:name=)
        .with 'Foo Bar'

      subject.send :sync_information
    end
  end

  describe 'helper methods' do
    before { allow(subject).to receive(:auth_hash).and_return auth_hash }

    describe '#email' do
      describe 'populated auth_hash' do
        let(:auth_hash) { { 'info' => { 'email' => 'foo@bar' }, 'extra' => { 'mail' => 'bar@foo' } } }

        it 'returns info.email' do
          expect(subject.send :email).to eq 'foo@bar'
        end
      end

      describe 'no info' do
        let(:auth_hash) { { 'extra' => { 'mail' => 'bar@foo' } } }

        it 'returns extra.mail' do
          expect(subject.send :email).to eq 'bar@foo'
        end
      end

      describe 'no email' do
        it 'returns nil' do
          expect(subject.send :email).to be_nil
        end
      end

      describe 'uppercase email' do
        let(:auth_hash) { { 'info' => { 'email' => 'FOO@BAR' } } }

        it 'downcases emails' do
          expect(subject.send :email).to eq 'foo@bar'
        end
      end
    end

    describe '#first_name' do
      describe 'populated auth_hash' do
        let(:auth_hash) { { 'info' => { 'name' => 'foo' }, 'extra' => { 'givenname' => 'bar' } } }

        it 'returns info.name' do
          expect(subject.send :first_name).to eq 'foo'
        end
      end

      describe 'no info' do
        let(:auth_hash) { { 'extra' => { 'givenname' => 'bar' } } }

        it 'returns extra.givenname' do
          expect(subject.send :first_name).to eq 'bar'
        end
      end

      describe 'no names' do
        it 'returns nil' do
          expect(subject.send :first_name).to be_nil
        end
      end
    end

    describe '#last_name' do
      describe 'populated auth_hash' do
        let(:auth_hash) { { 'extra' => { 'surname' => 'bar' } } }

        it 'returns surname' do
          expect(subject.send :last_name).to eq 'bar'
        end
      end

      describe 'empty auth_hash' do
        it 'returns nil' do
          expect(subject.send :last_name).to be_nil
        end
      end
    end
  end
end
