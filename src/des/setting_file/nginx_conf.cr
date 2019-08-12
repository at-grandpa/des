module Des
  module SettingFile
    class NginxConf
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
      end

      def build_file_create_info : Des::Cli::FileCreateInfo
        Des::Cli::FileCreateInfo.new(
          "#{@options.save_dir}/nginx.conf",
          to_s,
          @options.overwrite
        )
      end

      ECR.def_to_s "#{__DIR__}/nginx_conf/template.ecr"
    end
  end
end
