module Des
  module SettingFile
    class Dockerfile
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
      end

      def build_file_create_info : Des::Cli::FileCreateInfo
        Des::Cli::FileCreateInfo.new(
          "#{@options.save_dir}/Dockerfile",
          to_s,
          @options.overwrite
        )
      end

      ECR.def_to_s "#{__DIR__}/dockerfile/template.ecr"
    end
  end
end
