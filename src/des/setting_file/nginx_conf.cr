module Des
  module SettingFile
    class NginxConf
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
      end

      ECR.def_to_s "#{__DIR__}/nginx_conf.ecr"
    end
  end
end
