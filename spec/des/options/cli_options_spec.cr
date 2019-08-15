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
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        },
        expected: "crystallang/crystal",
      },
      {
        desc:              "return nil.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
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
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        },
        expected: ["vim", "curl"],
      },
      {
        desc:              "return empty array.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
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
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        },
        expected: "test_container",
      },
      {
        desc:              "return nil.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
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
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
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
  describe "#desrc_path" do
    [
      {
        desc:              "return string.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             "/path/to/file_path",
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        },
        expected: "/path/to/file_path",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        cli_options = Des::Options::CliOptions.new(spec_case["cli_options_input"])
        cli_options.desrc_path.should eq spec_case["expected"]
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
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: "100",
          web_app:                nil,
          overwrite:              nil,
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
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                "false",
          overwrite:              nil,
        },
        expected: false,
      },
      {
        desc:              "return true.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                "true",
          overwrite:              nil,
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
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              "false",
        },
        expected: false,
      },
      {
        desc:              "return true.",
        cli_options_input: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              "true",
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
  describe "#==" do
    [
      {
        desc:              "returns true for the nil values.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        expected: true,
      },
      {
        desc:              "returns true for the same values.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  "test_image",
          packages:               ["test_package"],
          container:              "test_conatiner",
          save_dir:               "test_save_dir",
          desrc_path:             "test_desrc_path",
          docker_compose_version: "test_docker_compose_version",
          web_app:                "true",
          overwrite:              "true",
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "test_image",
          packages:               ["test_package"],
          container:              "test_conatiner",
          save_dir:               "test_save_dir",
          desrc_path:             "test_desrc_path",
          docker_compose_version: "test_docker_compose_version",
          web_app:                "true",
          overwrite:              "true",
        }),
        expected: true,
      },
      {
        desc:              "returns false for the different image value.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "abx",
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        expected: false,
      },
      {
        desc:              "returns false for the different packages value.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abx"],
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        expected: false,
      },
      {
        desc:              "returns false for the different container value.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abx",
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        expected: false,
      },
      {
        desc:              "returns false for the different save_dir value.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abc",
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abx",
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        expected: false,
      },
      {
        desc:              "returns false for the different desrc_path value.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abc",
          desrc_path:             "abc",
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abc",
          desrc_path:             "abx",
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        expected: false,
      },
      {
        desc:              "returns false for the different docker_compose_version value.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abc",
          desrc_path:             "abc",
          docker_compose_version: "abc",
          web_app:                nil,
          overwrite:              nil,
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abc",
          desrc_path:             "abc",
          docker_compose_version: "abx",
          web_app:                nil,
          overwrite:              nil,
        }),
        expected: false,
      },
      {
        desc:              "returns false for the different web_app value.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abc",
          desrc_path:             "abc",
          docker_compose_version: "abc",
          web_app:                "true",
          overwrite:              nil,
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abc",
          desrc_path:             "abc",
          docker_compose_version: "abc",
          web_app:                "false",
          overwrite:              nil,
        }),
        expected: false,
      },
      {
        desc:              "returns false for the different overwrite value.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abc",
          desrc_path:             "abc",
          docker_compose_version: "abc",
          web_app:                "true",
          overwrite:              "true",
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "abc",
          packages:               ["abc"],
          container:              "abc",
          save_dir:               "abc",
          desrc_path:             "abc",
          docker_compose_version: "abc",
          web_app:                "true",
          overwrite:              "false",
        }),
        expected: false,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        (spec_case["cli_options_input"] == spec_case["other_options_input"]).should eq spec_case["expected"]
      end
    end
  end
  describe "#overwrite_values" do
    [
      {
        desc:              "return false.",
        cli_options_input: Des::Options::CliOptions.new({
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        other_options_input: Des::Options::CliOptions.new({
          image:                  "default image",
          packages:               ["default package"],
          container:              "default container",
          save_dir:               "default save_dir",
          desrc_path:             "default desrc_path",
          docker_compose_version: "default docker_compose_version",
          web_app:                "true",
          overwrite:              "true",
        }),
        target:   [nil, [] of String],
        expected: Des::Options::CliOptions.new({
          image:                  "default image",
          packages:               ["default package"],
          container:              "default container",
          save_dir:               "default save_dir",
          desrc_path:             "default desrc_path",
          docker_compose_version: "default docker_compose_version",
          web_app:                "true",
          overwrite:              "true",
        }),
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        spec_case["cli_options_input"].overwrite_values(spec_case["other_options_input"], spec_case["target"]).should eq spec_case["expected"]
      end
    end
  end
end
