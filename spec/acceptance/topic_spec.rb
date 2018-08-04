# frozen_string_literal: true

require 'rails_helper'

##
# Topic acceptance test
#
RSpec.describe 'Topic', :type => :request do
  ##
  # Configuration
  #
  before :each do
    OpenWebslides.configure do |config|
      ##
      # Absolute path to persistent repository storage
      #
      config.repository.path = Dir.mktmpdir
    end
  end

  ##
  # Test variables
  #
  let(:user) { create :user, :confirmed }

  let(:title) { Faker::Lorem.words(4).join(' ') }
  let(:description) { Faker::Lorem.words(20).join(' ') }

  ##
  # Tests
  #
  describe 'A user can create a topic' do
    it 'returns without any errors' do
      params = {
        :data => {
          :type => 'topics',
          :attributes => {
            :title => title,
            :description => description,
            :state => 'private_access'
          },
          :relationships => {
            :user => {
              :data => {
                :type => 'users',
                :id => user.id
              }
            }
          }
        }
      }

      headers = {
        'Content-Type' => 'application/vnd.api+json',
        'Accept' => 'application/vnd.api+json, application/vnd.openwebslides+json; version=3.0.0',
        'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
      }

      post '/api/topics', :params => params.to_json, :headers => headers

      expect(response.status).to eq 201
      data = JSON.parse(response.body)['data']
      expect(data['attributes']).to match 'title' => title,
                                          'description' => description,
                                          'state' => 'private_access'
    end
  end
end
