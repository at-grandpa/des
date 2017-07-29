require "spec"
require "../src/des"

alias Rc = Des::Rc
alias Opts = Des::Opts
alias Parameters = Des::Parameters
alias Dockerfile = Des::Dockerfile
alias Makefile = Des::Makefile
alias DockerCompose = Des::DockerCompose
alias DesrcYml = Des::DesrcYml

alias OptsParameter = Hash(String, String) | Hash(String, Bool) | Hash(String, Array(String))

class SpecCase
  @opts_parameters : Array(OptsParameter) = [] of OptsParameter

  getter describe, rc_file_yaml, opts_parameters, expect

  def initialize(@describe : String = "", @rc_file_yaml : String = "", opts_parameters = [] of OptsParameter, @expect : String = "")
    opts_parameters.each do |parameter|
      @opts_parameters << parameter
    end
  end
end
