module Des
  module SettingFile
    class DesrcFile
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
      end

      def build_file_create_info : Des::Cli::FileCreateInfo
        Des::Cli::FileCreateInfo.new(
          @options.desrc_path,
          to_s,
          @options.overwrite
        )
      end

      ECR.def_to_s "#{__DIR__}/desrc_file/template.ecr"
    end
  end
end
