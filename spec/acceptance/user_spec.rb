# frozen_string_literal: true

require 'rails_helper'

##
# User acceptance test
#
RSpec.describe 'User', :type => :request do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:user) { create :user, :confirmed, :password => 'abcd1234' }

  let(:name) { Faker::Name.name }

  ##
  # Tests
  #
  describe 'update account' do
    it 'returns successfully' do
      params = {
        :data => {
          :type => 'users',
          :id => user.id,
          :attributes => {
            :name => name,
            :locale => 'en',
            :alertEmails => false,
            :currentPassword => 'abcd1234',
            :password => 'abcd1235'
          }
        }
      }

      headers = {
        'Content-Type' => 'application/vnd.api+json',
        'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
        'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
      }

      patch "/api/users/#{user.id}", :params => params.to_json, :headers => headers

      expect(response.status).to eq 200

      json = JSON.parse(response.body)['data']

      expect(json['id']).to eq user.id.to_s
      expect(json['attributes']['name']).to eq name
      expect(json['attributes']['locale']).to eq 'en'
      expect(json['attributes']['alertEmails']).to eq false

      user.reload
      expect(user).to be_valid_password 'abcd1235'
    end
  end
end
