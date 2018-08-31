# frozen_string_literal: true

require 'rails_helper'

##
# Topic acceptance test
#
RSpec.describe 'Topic', :type => :request do
  ##
  # Configuration
  #
  before do
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
  context 'A guest' do
    describe 'cannot create a topic'
  end

  context 'A user' do
    describe 'cannot create a topic without title' do
      it 'returns a validation error' do
        params = {
          :data => {
            :type => 'topics',
            :attributes => {
              :rootContentItemId => 'ivks4jgtxr'
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
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
          'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
        }

        post '/api/topics', :params => params.to_json, :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      end
    end

    describe 'cannot create a topic with the same title as an existing topic belonging to the user' do
      before { create :topic, :title => title }

      it 'returns a validation error' do
        params = {
          :data => {
            :type => 'topics',
            :attributes => {
              :title => title,
              :description => description,
              :rootContentItemId => 'ivks4jgtxr'
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
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
          'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
        }

        post '/api/topics', :params => params.to_json, :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      end
    end

    describe 'can create a public topic' do
      it 'returns without any errors' do
        params = {
          :data => {
            :type => 'topics',
            :attributes => {
              :title => title,
              :description => description,
              :rootContentItemId => 'ivks4jgtxr'
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
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
          'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
        }

        post '/api/topics', :params => params.to_json, :headers => headers

        expect(response.status).to eq 201
        data = JSON.parse(response.body)['data']
        expect(data['attributes']).to match 'title' => title,
                                            'description' => description,
                                            'state' => 'public_access',
                                            'rootContentItemId' => 'ivks4jgtxr'
      end
    end

    describe 'can create a protected topic' do
      it 'returns without any errors' do
        params = {
          :data => {
            :type => 'topics',
            :attributes => {
              :title => title,
              :description => description,
              :state => 'protected_access',
              :rootContentItemId => 'ivks4jgtxr'
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
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
          'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
        }

        post '/api/topics', :params => params.to_json, :headers => headers

        expect(response.status).to eq 201
        data = JSON.parse(response.body)['data']
        expect(data['attributes']).to match 'title' => title,
                                            'description' => description,
                                            'state' => 'protected_access',
                                            'rootContentItemId' => 'ivks4jgtxr'
      end
    end

    describe 'can create a private topic' do
      it 'returns without any errors' do
        params = {
          :data => {
            :type => 'topics',
            :attributes => {
              :title => title,
              :description => description,
              :state => 'private_access',
              :rootContentItemId => 'ivks4jgtxr'
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
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
          'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
        }

        post '/api/topics', :params => params.to_json, :headers => headers

        expect(response.status).to eq 201
        data = JSON.parse(response.body)['data']
        expect(data['attributes']).to match 'title' => title,
                                            'description' => description,
                                            'state' => 'private_access',
                                            'rootContentItemId' => 'ivks4jgtxr'
      end
    end

    describe 'can retrieve the contents of a topic' do
      let(:topic) { create :topic, :root_content_item_id => 'qyrgv0bcd6' }

      before do
        # Make sure the topic repository is created
        Topics::Create.call topic

        # Populate the topic with some dummy content
        Contents::Update.call topic, user, content, 'Update content'
      end

      it 'returns without any errors' do
        headers = {
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
        }

        get "/api/topics/#{topic.id}/content", :headers => headers

        expect(response.status).to eq 200
        data = JSON.parse(response.body)['data']['attributes']
        expect(data['content']).to match_array content
      end
    end
  end

  context 'An owner' do
    describe 'can delete a topic' do
      let(:topic) { create :topic, :user => user }

      before do
        # Make sure the topic repository is created
        Topics::Create.call topic
      end

      it 'returns without any errors' do
        headers = {
          'Content-Type' => 'application/vnd.api+json',
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
          'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
        }

        delete "/api/topics/#{topic.id}", :headers => headers

        expect(response.status).to eq 204

        get "/api/topics/#{topic.id}", :headers => headers

        expect(response.status).to eq 404
      end
    end
  end
end
