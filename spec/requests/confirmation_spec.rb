# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Confirmation API', :type => :request do
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
  let(:user) { create :user }

  ##
  # Request variables
  #
  def create_body(email)
    {
      :data => {
        :type => 'confirmations',
        :attributes => {
          :email => email
        }
      }
    }.to_json
  end

  def update_body(token)
    {
      :data => {
        :type => 'confirmations',
        :attributes => {
          :confirmationToken => token
        }
      }
    }.to_json
  end

  ##
  # Tests
  #
  describe 'POST /' do
    before { post confirmation_path, :params => create_body(email), :headers => headers }

    let(:email) { user.email }

    it { is_expected.to have_http_status :no_content }

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
    before { patch confirmation_path, :params => update_body(token), :headers => headers }

    let(:token) { user.confirmation_token }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_record user }

    it 'confirmed the user' do
      user.reload
      expect(user).to be_confirmed
    end

    context 'when the token is invalid' do
      let(:token) { 'foo' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the user is already confirmed' do
      let(:user) { create :user, :confirmed }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end
  end
end
