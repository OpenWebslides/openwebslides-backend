# frozen_string_literal: true

require 'rails_helper'

# It is never a good idea to write dependent tests. However, writing a dummy
# VersioningController specifically for this test would imply creating a dummy
# route, resource and policy as well. To keep things simple UsersController is the test subject
RSpec.describe UsersController do
  describe 'request Accept header' do
    before :each do
      request.headers['Accept'] = accept_header
    end

    describe 'no header' do
      let(:accept_header) { '' }

      it 'returns a 406' do
        get :index

        expect(response.status).to eq 406
      end
    end

    describe 'no version in header' do
      let(:accept_header) { 'application/vnd.api+json' }

      it 'fails' do
        get :index

        expect(response.status).to eq 406
      end
    end

    describe 'exact version' do
      let(:accept_header) { "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}" }

      it 'succeeds' do
        get :index

        expect(response.status).to eq 200
      end
    end

    describe 'incompatible version' do
      let(:accept_header) { 'application/vnd.api+json, application/vnd.openwebslides+json; version=1.0.0' }

      it 'fails' do
        get :index

        expect(response.status).to eq 406
      end
    end

    describe 'invalid mime type' do
      let(:accept_header) { 'application/vnd.api+json, application/vnd.foobar+json; version=1.0.0' }

      it 'fails' do
        get :index

        expect(response.status).to eq 406
      end
    end
  end

  describe 'response Content-Type header' do
    before :each do
      request.headers['Accept'] = "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'returns a valid Content-Type header' do
      get :index

      expect(response.headers['Content-Type']).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end
  end
end
