# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :lock_with do |type|
  match do |file|
    File.open(file, File::RDWR | File::CREAT, 0o644) do |lock|
      locked = lock.flock type | File::LOCK_NB

      lock.flock File::LOCK_UN unless locked

      expect(locked).not_to be false
    end
  end
end
