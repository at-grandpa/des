module Des
  module SettingFile
    module OptionsInterface
      abstract def initialize(
        @cli_options : Des::Options::CliOptions,
        @desrc_file_options : Des::Options::DesrcFileOptions
      )
      abstract def image : String
      abstract def packages : Array(String)
      abstract def container : String
      abstract def save_dir : String
      abstract def docker_compose_version : String
      abstract def web_app : Bool
      abstract def overwrite : Bool
    end
  end
end
