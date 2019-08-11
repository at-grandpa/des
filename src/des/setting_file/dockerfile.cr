module Des
  module SettingFile
    class Dockerfile
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
      end

      ECR.def_to_s "#{__DIR__}/dockerfile/template.ecr"
    end
  end
end
