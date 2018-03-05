# frozen_string_literal: true

module Repository
  module Remote
    ##
    # Create remote repository
    #
    class Init < RepoCommand
      def execute
        return unless OpenWebslides.config.github.enabled

        options = {
          :description => @receiver.description || 'OpenWebslides slidetopic',
          :private => !@receiver.public_access?,
          :has_issues => false,
          :has_wiki => false,
          :has_downloads => false,
          :organization => OpenWebslides.config.github.organization
        }

        Octokit.create_repository @receiver.canonical_name, options

        # Set local repo remotes
        repo = Rugged::Repository.new repo_path

        host = "#{OpenWebslides.config.github.ssh_user}@#{OpenWebslides.config.github.ssh_host}"
        path = "#{OpenWebslides.config.github.organization}/#{@receiver.canonical_name}.git"
        remote = "#{host}:#{path}"

        # Repository was cloned, already has an 'origin' remote
        repo.remotes.delete 'origin' if repo.remotes.any?
        repo.remotes.create 'origin', remote
      end
    end
  end
end
