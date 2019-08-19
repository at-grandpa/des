require "spec"
require "mocks"
require "mocks/spec"
require "../src/des"

class OptionsMock
  include Des::SettingFile::OptionsInterface

  def initialize(
    @cli_options : Des::Options::CliOptions,
    @desrc_file_options : Des::Options::DesrcFileOptions
  )
  end

  def image : String
    ""
  end

  def packages : Array(String)
    [] of String
  end

  def container : String
    ""
  end

  def save_dir : String
    ""
  end

  def docker_compose_version : String
    ""
  end

  def web_app : Bool
    false
  end

  def overwrite : Bool
    false
  end

  def ==(other : self) : Bool
    true
  end
end

Mocks.create_mock OptionsMock do
  mock image
  mock packages
  mock container
  mock save_dir
  mock docker_compose_version
  mock web_app
  mock overwrite
end

Mocks.create_mock Des::Options::CliOptions do
  mock image
  mock packages
  mock container
  mock save_dir
  mock docker_compose_version
  mock web_app
  mock overwrite
end

Mocks.create_mock Des::Options::DesrcFileOptions do
  mock image
  mock packages
  mock container
  mock save_dir
  mock docker_compose_version
  mock web_app
  mock overwrite
end
