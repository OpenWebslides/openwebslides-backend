# frozen_string_literal: true

RSpec.shared_context 'repository', :shared_context => :metadata do
  around do |example|
    temp_dir = Dir.mktmpdir

    OpenWebslides.configure do |config|
      ##
      # Absolute path to persistent repository storage
      #
      config.repository.path = temp_dir
    end

    example.run

    FileUtils.rm_rf temp_dir
  end
end
