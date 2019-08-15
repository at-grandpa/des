module Des
  module SettingFile
    class DesrcFile
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
        default_cli_options = Des::Options::CliOptions.new({
          image:                  "input image",
          packages:               [] of String,
          container:              "default container",
          save_dir:               "default save_dir",
          desrc_path:             "default desrc_path",
          docker_compose_version: "input docker_compose_version",
          web_app:                "true",
          overwrite:              "false",
        })
        @options.overwrite_cli_options!(default_cli_options)
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
