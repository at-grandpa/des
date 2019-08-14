module Des
  module SettingFile
    class DesrcFile
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
        desrc_default_option = {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }
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
