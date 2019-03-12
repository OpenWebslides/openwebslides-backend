# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User API', :type => :request do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject { response }

  ##
  # Test variables
  #
  let(:user) { create :user, :confirmed, :password => password }

  let(:name) { Faker::Name.name }
  let(:password) { Faker::Internet.password 6 }

  ##
  # Request variables
  #
  let(:attributes) do
    {
      :email => Faker::Internet.email,
      :name => name,
      :password => password,
      :tosAccepted => true
    }
  end

  def create_body(attributes)
    {
      :data => {
        :type => 'users',
        :attributes => attributes
      }
    }.to_json
  end

  def update_body(id, attributes)
    {
      :data => {
        :type => 'users',
        :id => id,
        :attributes => attributes
      }
    }.to_json
  end

  ##
  # Tests
  #

  describe 'GET /' do
    before { create_list :user, 3 }

    before { get users_path, :headers => headers }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_records User.all }
    it { is_expected.to have_record_count 3 }
  end

  describe 'POST /' do
    before { post users_path, :params => create_body(attrs), :headers => headers }

    let(:attrs) { attributes }

    it { is_expected.to have_http_status :created }
    it { is_expected.to have_attribute(:name).with_value name }

    context 'when a user with the same email already exists' do
      let(:attrs) { attributes.merge :email => user.email }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when ToS is not accepted' do
      let(:attrs) { attributes.merge :tosAccepted => false }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the password is empty' do
      let(:attrs) { attributes.merge :password => '' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the name is empty' do
      let(:attrs) { attributes.merge :name => '' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_error.with_code JSONAPI::VALIDATION_ERROR }
    end
  end

  describe 'GET /:id' do
    before { get user_path(:id => id), :headers => headers }

    let(:id) { user.id }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_record user }
    it { is_expected.to have_attribute(:gravatarHash).with_value Digest::MD5.hexdigest(user.email) }

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end
  end

  describe 'PUT/PATCH /:id' do
    before { patch user_path(:id => id), :params => update_body(id, attrs), :headers => headers(:access) }

    let(:id) { user.id }
    let(:attrs) { { :name => 'foobar' } }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_record user }

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end

    context 'when email changes' do
      let(:attrs) { { :email => 'foo@bar' } }

      it { is_expected.to have_http_status :bad_request }
      it { is_expected.to have_error.with_code JSONAPI::PARAM_NOT_ALLOWED }
    end

    context 'when password changes and current password is empty' do
      let(:attrs) { { :password => 'abcd1234' } }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when password changes and current password is invalid' do
      let(:attrs) { { :password => 'abcd1234', :currentPassword => 'foobar' } }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when password changes and current password is valid' do
      let(:attrs) { { :password => 'abcd1234', :currentPassword => password } }

      it { is_expected.to have_http_status :ok }

      it 'changes password' do
        user.reload
        expect(user).to be_valid_password 'abcd1234'
      end
    end

    context 'when email notifications are disabled' do
      let(:attrs) { { :alertEmails => false } }

      it { is_expected.to have_http_status :ok }

      it 'disables email notifications' do
        user.reload
        expect(user).not_to be_alert_emails
      end
    end
  end

  describe 'DELETE /:id' do
    before { delete user_path(:id => id), :headers => headers(:access) }

    let(:id) { user.id }

    it { is_expected.to have_http_status :no_content }

    it 'is destroyed' do
      expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end
  end
end
