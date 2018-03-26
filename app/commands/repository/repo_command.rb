# frozen_string_literal: true

module Repository
  ##
  # Repository command
  #
  class RepoCommand < Command
    protected

    def repo_path
      File.join OpenWebslides.config.repository_path, @receiver.user.id.to_s, @receiver.id.to_s
    end

    def repo_file
      File.join repo_path, 'data.yml'
    end

    def lock_path
      File.join Rails.root.join 'tmp', 'locks'
    end

    ##
    # Exclusively lock a repository
    #
    def write_lock(&block)
      lock File::LOCK_EX, block
    end

    ##
    # Shared lock a repository
    #
    def read_lock(&block)
      lock File::LOCK_SH, block
    end

    private

    def lock(type, block)
      Dir.mkdir lock_path unless Dir.exist? lock_path

      file = File.join lock_path, "#{@receiver.id}.lock"

      File.open(file, File::RDWR | File::CREAT, 0o644) do |lock|
        lock.flock type

        block.call
      ensure
        lock.flock File::LOCK_UN
      end
    end
  end
end
