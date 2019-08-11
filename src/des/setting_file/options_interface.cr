module Des
  module SettingFile
    module OptionsInterface
      abstract def initialize(
        @cli_options : Des::Options::CliOptions,
        @des_rc_file_options : Des::Options::DesRcFileOptions
      )
      abstract def container : String
      abstract def docker_compose_version : String
      abstract def web_app : Bool
    end
  end
end
