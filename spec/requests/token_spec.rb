# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Token API', :type => :request do
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
  let(:user) { create :user, :confirmed, :password => 'foobar' }

  ##
  # Request variables
  #
  def create_body(email, password)
    {
      :data => {
        :type => 'tokens',
        :attributes => {
          :email => email,
          :password => password
        }
      }
    }.to_json
  end

  ##
  # Tests
  #
  describe 'POST /' do
    before { post token_path, :params => create_body(user.email, password), :headers => headers }

    let(:password) { 'foobar' }

    it { is_expected.to have_http_status :created }
    it { is_expected.to return_token JWT::Auth::RefreshToken }
    it { is_expected.to have_jsonapi_record user }

    context 'when the credentials are incorrect' do
      let(:password) { 'barfoo' }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end

    context 'when the user is not confirmed' do
      let(:user) { create :user, :password => 'foobar' }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end
  end

  describe 'PATCH /' do
    before { patch token_path, :headers => headers(header_tags) }

    let(:header_tags) { :refresh }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to return_token JWT::Auth::AccessToken }
    it { is_expected.to have_jsonapi_record user }

    context 'when the user is not confirmed' do
      let(:user) { create :user, :password => 'foobar' }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end

    context 'when the token is invalid' do
      let(:header_tags) { nil }

      append_before do
        # Temporarily set a fake, invalid token version
        user.assign_attributes :token_version => 999

        # Generate a token with this invalid token version
        request.headers['Authorization'] = "Bearer #{JWT::Auth::AccessToken.new(:subject => user).to_jwt}"

        # Reload real token version
        user.reload
      end

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end

    context 'when no token is present' do
      let(:header_tags) { nil }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end

    context 'when an access token is present' do
      let(:header_tags) { :access }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end
  end

  describe 'DELETE /' do
    before { delete token_path, :headers => headers(header_tags) }

    prepend_before { @version = user.token_version }

    let(:header_tags) { :refresh }

    it { is_expected.to have_http_status :no_content }
    it { is_expected.not_to return_token }

    it 'increments the token_version' do
      user.reload
      expect(user.token_version).to eq @version + 1 # rubocop:disable RSpec/InstanceVariable
    end

    context 'when the user is not confirmed' do
      let(:user) { create :user, :password => 'foobar' }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end

    context 'when the token is invalid' do
      let(:header_tags) { nil }

      append_before do
        # Temporarily set a fake, invalid token version
        user.assign_attributes :token_version => 999

        # Generate a token with this invalid token version
        request.headers['Authorization'] = "Bearer #{JWT::Auth::RefreshToken.new(:subject => user).to_jwt}"

        # Reload real token version
        user.reload
      end

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end

    context 'when no token is present' do
      let(:header_tags) { nil }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end

    context 'when an access token is present' do
      let(:header_tags) { :access }

      it { is_expected.to have_http_status :unauthorized }
      it { is_expected.not_to return_token }
    end
  end
end
