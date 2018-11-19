# frozen_string_literal: true

require 'rails_helper'

# It is never a good idea to write dependent tests. However, writing a dummy
# VersioningController specifically for this test would imply creating a dummy
# route, resource and policy as well. To keep things simple UsersController is the test subject
RSpec.describe UsersController do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  ##
  # Tests
  #
  describe 'request Accept header' do
    before do
      request.headers['Accept'] = accept_header
      get :index
    end

    context 'when it is malformed' do
      let(:accept_header) { 'foobar' }

      it { is_expected.to respond_with :not_acceptable }
    end

    context 'when it is empty' do
      let(:accept_header) { '' }

      it { is_expected.to respond_with :not_acceptable }
    end

    context 'when it specifies no version' do
      let(:accept_header) { 'application/vnd.api+json' }

      it { is_expected.to respond_with :not_acceptable }
    end

    context 'when it specifies an exact version' do
      let(:accept_header) { "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}" }

      it { is_expected.to respond_with :ok }
    end

    context 'when it specifies an exact incompatible version' do
      let(:accept_header) { 'application/vnd.api+json, application/vnd.openwebslides+json; version=1.0.0' }

      it { is_expected.to respond_with :not_acceptable }
    end

    context 'when it specifies an invalid mime type' do
      let(:accept_header) { 'application/vnd.api+json, application/vnd.foobar+json; version=1.0.0' }

      it { is_expected.to respond_with :not_acceptable }
    end
  end

  describe 'response Content-Type header' do
    before { request.headers['Accept'] = "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}" }

    it 'returns a valid Content-Type header' do
      get :index

      expect(response.headers['Content-Type']).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end
  end

  describe '#compatible_request_version?' do
    before { allow(OpenWebslides.config.api).to receive(:version).and_return '2.5.3' }

    describe 'strict operator' do
      it { is_expected.not_to be_compatible_with '1' }
      it { is_expected.not_to be_compatible_with '2' }
      it { is_expected.not_to be_compatible_with '3' }

      it { is_expected.not_to be_compatible_with '2.4' }
      it { is_expected.not_to be_compatible_with '2.5' }
      it { is_expected.not_to be_compatible_with '2.6' }

      it { is_expected.not_to be_compatible_with '2.5.2' }
      it { is_expected.to be_compatible_with '2.5.3' }
      it { is_expected.not_to be_compatible_with '2.5.4' }
    end

    describe 'twiddle wakka operator' do
      it { is_expected.not_to be_compatible_with '~>1' }
      it { is_expected.to be_compatible_with '~>2' }
      it { is_expected.not_to be_compatible_with '~>3' }

      it { is_expected.to be_compatible_with '~>2.4' }
      it { is_expected.to be_compatible_with '~>2.5' }
      it { is_expected.not_to be_compatible_with '~>2.6' }

      it { is_expected.to be_compatible_with '~>2.5.2' }
      it { is_expected.to be_compatible_with '~>2.5.3' }
      it { is_expected.not_to be_compatible_with '~>2.5.4' }
    end
  end
end
