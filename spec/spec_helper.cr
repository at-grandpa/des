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

  def save_dir : String
    ""
  end
end

Mocks.create_mock OptionsMock do
  mock image
end

Mocks.create_mock Des::SettingFile::FileCreator do
  mock hoge
end
