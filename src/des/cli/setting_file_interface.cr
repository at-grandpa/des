require "ecr"

module Des
  module Cli
    module SettingFileInterface
      abstract def initialize(@options : Des::SettingFile::OptionsInterface)
      abstract def to_s : String
    end
  end
end
