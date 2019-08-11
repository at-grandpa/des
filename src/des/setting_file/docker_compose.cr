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

        ECR.def_to_s "#{__DIR__}/docker_compose/default_template.ecr"
      end

      class WebApp
        include Des::Cli::SettingFileInterface

        def initialize(@options : Des::SettingFile::OptionsInterface)
        end

        ECR.def_to_s "#{__DIR__}/docker_compose/web_app_template.ecr"
      end

      def to_s : String
        if @options.web_app
          WebApp.new(@options).to_s
        else
          Default.new(@options).to_s
        end
      end
    end
  end
end
