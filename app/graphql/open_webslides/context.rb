# frozen_string_literal: true

module OpenWebslides
  class Context < GraphQL::Query::Context
    def current_user
      self[:current_user]
    end

    def pundit
      self[:pundit]
    end
  end
end
