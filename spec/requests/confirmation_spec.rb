# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Confirmation API', :type => :request do
  let(:unconfirmed_user) { create :user }
  let(:user) { create :user, :confirmed }

  def request_body(email)
    {
      :data => {
        :type => 'confirmations',
        :attributes => {
          :email => email
        }
      }
    }.to_json
  end

  def confirm_body(token)
    {
      :data => {
        :id => '',
        :type => 'confirmations',
        :attributes => {
          :confirmationToken => token
        }
      }
    }.to_json
  end

  describe 'POST /' do
    before do
      add_content_type_header
    end

    it 'accepts confirmed users' do
      post confirmation_path, :params => request_body(user.email), :headers => headers

      expect(response.status).to eq 204
    end

    it 'accepts invalid emails' do
      post confirmation_path, :params => request_body('foo'), :headers => headers

      expect(response.status).to eq 204
    end

    it 'requests a password reset token' do
      post confirmation_path, :params => request_body(unconfirmed_user.email), :headers => headers

      expect(response.status).to eq 204
    end
  end

  describe 'PATCH /' do
    before do
      add_content_type_header
    end

    it 'rejects invalid confirmation tokens' do
      patch confirmation_path, :params => confirm_body('foo'), :headers => headers

      expect(response.status).to eq 422
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'rejects already confirmed users' do
      expect(user).to be_confirmed

      patch confirmation_path, :params => confirm_body(user.confirmation_token), :headers => headers

      expect(response.status).to eq 422
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'confirms a user' do
      expect(unconfirmed_user).not_to be_confirmed

      patch confirmation_path, :params => confirm_body(unconfirmed_user.confirmation_token), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE

      unconfirmed_user.reload
      expect(unconfirmed_user).to be_confirmed
    end
  end
end
