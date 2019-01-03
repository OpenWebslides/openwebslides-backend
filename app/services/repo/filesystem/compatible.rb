# frozen_string_literal: true

module Repo
  module Filesystem
    ##
    # Validate data format version compatibility
    #
    class Compatible < ApplicationService
      def call(repo)
        raise OpenWebslides::Repo::RepoDoesNotExistError unless Dir.exist? repo.path

        constraint = Semverse::Constraint.new "~> #{OpenWebslides.config.repository.version}"

        version = YAML.safe_load(File.read(repo.index))['version']

        # Return compatibility value
        constraint.satisfies? version
      end
    end
  end
end
