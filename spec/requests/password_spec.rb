# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Password API', :type => :request do
  ##
  # Configuration
  #
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
  let(:user) { create :user, :password => password }

  let(:password) { Faker::Internet.password 6 }
  let(:new_password) { Faker::Internet.password 6 }

  ##
  # Request variables
  #
  def create_body(email)
    {
      :data => {
        :type => 'passwords',
        :attributes => {
          :email => email
        }
      }
    }.to_json
  end

  def update_body(token, password)
    {
      :data => {
        :type => 'passwords',
        :attributes => {
          :resetPasswordToken => token,
          :password => password
        }
      }
    }.to_json
  end

  ##
  # Tests
  #
  describe 'POST /' do
    before { post password_path, :params => create_body(email), :headers => headers }

    let(:email) { user.email }

    it { is_expected.to have_http_status :no_content }

    describe 'resets the password' do
      subject { user }

      before { user.reload }

      it { is_expected.to be_valid_password password }
      it { is_expected.not_to be_valid_password new_password }
    end

    context 'when the user is already confirmed' do
      let(:user) { create :user, :confirmed }

      it { is_expected.to have_http_status :no_content }
    end

    context 'when the email is invalid' do
      let(:email) { 'foo' }

      it { is_expected.to have_http_status :no_content }
    end
  end

  describe 'PUT/PATCH /' do
    before { patch password_path, :params => update_body(token, new_password), :headers => headers }

    let(:token) { user.send_reset_password_instructions }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_record user }

    describe 'resets the password' do
      subject { user }

      before { user.reload }

      it { is_expected.not_to be_valid_password password }
      it { is_expected.to be_valid_password new_password }
    end

    context 'when the token is invalid' do
      let(:token) { 'foo' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the user is already confirmed' do
      let(:user) { create :user, :confirmed }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to have_jsonapi_record user }

      describe 'resets the password' do
        subject { user }

        before { user.reload }

        it { is_expected.not_to be_valid_password password }
        it { is_expected.to be_valid_password new_password }
      end
    end
  end
end
