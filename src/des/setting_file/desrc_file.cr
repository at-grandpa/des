module Des
  module SettingFile
    class DesrcFile
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
        default_cli_options = Des::Options::CliOptions.new({
          image:                  "ubuntu:18.04",
          packages:               [] of String,
          container:              "default_container",
          save_dir:               ".",
          desrc_path:             "~/.desrc.yml",
          docker_compose_version: "3",
          web_app:                "false",
          overwrite:              "false",
        })
        @options.overwrite_cli_options!(default_cli_options, [nil])
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
