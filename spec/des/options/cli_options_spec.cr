require "../../spec_helper"

describe Des::Options::CliOptions do
  describe "#image" do
    [
      {
        desc:              "return string.",
        cli_options_input: {
          image:                  "crystallang/crystal",
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: "crystallang/crystal",
      },
      {
        desc:              "return nil.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: nil,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.image.should eq spec_case["expected"]
      end
    end
  end
  describe "#packages" do
    [
      {
        desc:              "return packages array.",
        cli_options_input: {
          image:                  nil,
          packages:               ["vim", "curl"],
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: ["vim", "curl"],
      },
      {
        desc:              "return empty array.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: [] of String,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.packages.should eq spec_case["expected"]
      end
    end
  end
  describe "#container" do
    [
      {
        desc:              "return string.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              "test_container",
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: "test_container",
      },
      {
        desc:              "return nil.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: nil,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.container.should eq spec_case["expected"]
      end
    end
  end
  describe "#save_dir" do
    [
      {
        desc:              "return string.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "/path/to/test_dir",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: "/path/to/test_dir",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.save_dir.should eq spec_case["expected"]
      end
    end
  end
  describe "#rc_file" do
    [
      {
        desc:              "return string.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "/path/to/file_path",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: "/path/to/file_path",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.rc_file.should eq spec_case["expected"]
      end
    end
  end
  describe "#docker_compose_version" do
    [
      {
        desc:              "return string.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "100",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: "100",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.docker_compose_version.should eq spec_case["expected"]
      end
    end
  end
  describe "#web_app" do
    [
      {
        desc:              "return false.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: false,
      },
      {
        desc:              "return true.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                true,
          overwrite:              false,
          desrc:                  false,
        },
        expected: true,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.web_app.should eq spec_case["expected"]
      end
    end
  end
  describe "#overwrite" do
    [
      {
        desc:              "return false.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: false,
      },
      {
        desc:              "return true.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              true,
          desrc:                  false,
        },
        expected: true,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.overwrite.should eq spec_case["expected"]
      end
    end
  end
  describe "#desrc" do
    [
      {
        desc:              "return false.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        expected: false,
      },
      {
        desc:              "return true.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               "dummy data",
          rc_file:                "dummy data",
          docker_compose_version: "dummy data",
          web_app:                false,
          overwrite:              false,
          desrc:                  true,
        },
        expected: true,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.desrc.should eq spec_case["expected"]
      end
    end
  end
end
