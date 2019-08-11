module Des
  module SettingFile
    module OptionsInterface
      abstract def initialize(
        @cli_options : Des::Options::CliOptions,
        @des_rc_file_options : Des::Options::DesRcFileOptions
      )
      abstract def image : String
    end
  end
end
