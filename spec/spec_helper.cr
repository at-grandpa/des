require "spec"
require "mocks"
require "mocks/spec"
require "../src/des"

class OptionsMock
  include Des::SettingFile::OptionsInterface

  def initialize(
    @cli_options : Des::Options::CliOptions,
    @des_rc_file_options : Des::Options::DesRcFileOptions
  )
  end

  def container : String
    ""
  end

  def docker_compose_version : String
    ""
  end

  def web_app : Bool
    false
  end
end

Mocks.create_mock OptionsMock do
  mock container
  mock docker_compose_version
  mock web_app
end
