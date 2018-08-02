# frozen_string_literal: true

require 'rspec/mocks'

##
# Create a stub for an arbitrary class
#
class Stub
  include RSpec::Mocks::ExampleMethods
  include RSpec::Mocks::Syntax

  attr_accessor :stubbed_class, :stub_double

  def initialize(stubbed_class)
    @stubbed_class = stubbed_class
    @stub_double = double stubbed_class.to_s

    allow(stubbed_class).to receive(:new)
      .and_return @stub_double
  end

  ##
  # Stub out a method on the stubbed class
  #
  def stub(method_sym)
    allow(@stub_double).to receive method_sym
  end

  ##
  # Create the stub
  #
  # Call with a block to stub out methods (see #stub)
  #
  def self.create(stubbed_class, stubbed_methods = [])
    stub = Stub.new stubbed_class

    Array(stubbed_methods).each { |m| stub.stub m }
  end

  class Command
    def self.create(stubbed_class, stubbed_methods = [])
      Stub.create stubbed_class, stubbed_methods.concat(%i[execute])
    end
  end
end
