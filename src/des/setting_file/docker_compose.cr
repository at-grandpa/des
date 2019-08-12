module Des
  module SettingFile
    class DockerCompose
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
      end

      class Default
        include Des::Cli::SettingFileInterface

        def initialize(@options : Des::SettingFile::OptionsInterface)
        end

        def build_file_create_info : Des::Cli::FileCreateInfo
          Des::Cli::FileCreateInfo.new(
            "#{@options.save_dir}/docker-compose.yml",
            to_s,
            @options.overwrite
          )
        end

        ECR.def_to_s "#{__DIR__}/docker_compose/default_template.ecr"
      end

      class WebApp
        include Des::Cli::SettingFileInterface

        def initialize(@options : Des::SettingFile::OptionsInterface)
        end

        def build_file_create_info : Des::Cli::FileCreateInfo
          Des::Cli::FileCreateInfo.new(
            "#{@options.save_dir}/docker-compose.yml",
            to_s,
            @options.overwrite
          )
        end

        ECR.def_to_s "#{__DIR__}/docker_compose/web_app_template.ecr"
      end

      def build_file_create_info : Des::Cli::FileCreateInfo
        if @options.web_app
          WebApp.new(@options).build_file_create_info
        else
          Default.new(@options).build_file_create_info
        end
      end
    end
  end
end
