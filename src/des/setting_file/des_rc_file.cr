module Des
  module SettingFile
    class DesRcFile
      include Des::Cli::SettingFileInterface

      def initialize(@options : Des::SettingFile::OptionsInterface)
      end

      ECR.def_to_s "#{__DIR__}/des_rc_file/template.ecr"
    end
  end
end
