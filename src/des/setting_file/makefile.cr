module Des
  module SettingFile
    class Makefile
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
      end

      ECR.def_to_s "#{__DIR__}/makefile/template.ecr"
    end
  end
end
