module Des
  module SettingFile
    class DesrcFile
      include Des::Cli::SettingFileInterface

      DESRC_FILE_PATH = File.expand_path("~/.desrc.yml")

      def initialize(@options : Des::SettingFile::OptionsInterface, @desrc_file_path : String = DESRC_FILE_PATH)
      end

      def build_file_create_info : Des::Cli::FileCreateInfo
        Des::Cli::FileCreateInfo.new(
          @desrc_file_path,
          to_s,
          false
        )
      end

      ECR.def_to_s "#{__DIR__}/desrc_file/template.ecr"
    end
  end
end
