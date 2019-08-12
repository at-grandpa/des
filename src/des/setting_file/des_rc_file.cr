module Des
  module SettingFile
    class DesRcFile
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
      end

      def build_file_create_info : Des::Cli::FileCreateInfo
        Des::Cli::FileCreateInfo.new(
          "#{@options.save_dir}/desrc.yml",
          to_s,
          @options.overwrite
        )
      end

      ECR.def_to_s "#{__DIR__}/des_rc_file/template.ecr"
    end
  end
end
