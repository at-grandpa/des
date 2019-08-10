require "spec"
require "../src/des"

alias Rc = Des::Rc
alias Opts = Des::Opts
alias Parameters = Des::Parameters
alias Dockerfile = Des::Dockerfile
alias Makefile = Des::Makefile
alias DockerCompose = Des::DockerCompose
alias DesrcYml = Des::DesrcYml

class SpecCase
  getter describe, rc_file_yaml, cli_options, expect
  DEFAULT_CLI_OPTIONS = Des::CliOptions.new(
    image: nil,
    packages: [] of String,
    container: nil,
    save_dir: nil,
    rc_file: "dummy_path",
    docker_compose_version: "3",
    web_app: false,
    overwrite: false,
    desrc: false
  )

  def initialize(
    @describe : String = "",
    @rc_file_yaml : String = "",
    @cli_options : Des::CliOptions = DEFAULT_CLI_OPTIONS,
    @expect : String = ""
  )
  end
end
