# frozen_string_literal: true

require 'rails_helper'

class VersioningController < ApplicationController
  attr_accessor :accept

  def initialize(accept)
    @accept = accept
  end

  def self.before_action; end

  def request
    OpenStruct.new :accept => @accept
  end

  include Versioning
end

RSpec.describe VersioningController do
  let(:subject) { described_class.new accept_header }

  describe 'no header' do
    let(:accept_header) { '' }

    it 'fails' do
      expect(-> { subject.verify_accept_header_version }).to raise_error JSONAPI::Exceptions::UnacceptableVersionError
    end
  end

  describe 'no version in header' do
    let(:accept_header) { 'application/vnd.api+json' }

    it 'fails' do
      expect(-> { subject.verify_accept_header_version }).to raise_error JSONAPI::Exceptions::UnacceptableVersionError
    end
  end

  describe 'exact version' do
    let(:accept_header) { "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}" }

    it 'succeeds' do
      expect(subject.verify_accept_header_version).to be true
    end
  end

  describe 'incompatible version' do
    let(:accept_header) { 'application/vnd.api+json, application/vnd.openwebslides+json; version=1.0.0' }

    it 'fails' do
      expect(-> { subject.verify_accept_header_version }).to raise_error JSONAPI::Exceptions::UnacceptableVersionError
    end
  end

  describe 'invalid mime type' do
    let(:accept_header) { 'application/vnd.api+json, application/vnd.foobar+json; version=1.0.0' }

    it 'fails' do
      expect(-> { subject.verify_accept_header_version }).to raise_error JSONAPI::Exceptions::UnacceptableVersionError
    end
  end
end
