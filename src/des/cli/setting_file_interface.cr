require "ecr"

module Des
  module Cli
    module SettingFileInterface
      abstract def initialize(@options : Des::SettingFile::OptionsInterface)
      # abstract def build_file_create_info : Des::Cli::FileCreateInfo
    end
  end
end
