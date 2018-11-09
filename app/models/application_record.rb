# frozen_string_literal: true

##
# Abstract database record
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  ##
  # Dummy method to define an attribute
  #
  def self.attribute(*args); end
end
