require "../../spec_helper"

describe Des::SettingFile::Dockerfile do
  describe "#to_s" do
    [
      {
        desc:         "return dockerfile string.",
        mock_setting: {
          image:     "crystallang/crystal",
          packages:  ["vim", "curl"],
          container: "test_container",
          save_dir:  "/path/to/dir",
          overwrite: false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/path/to/dir/Dockerfile",
          <<-STRING,
          FROM crystallang/crystal

          RUN apt-get -y update
          RUN apt-get -y upgrade
          RUN apt-get -y install vim curl

          WORKDIR /root/test_container

          STRING
          false
        ),
      },
      {
        desc:         "return dockerfile string other parameter version.",
        mock_setting: {
          image:     "mysql:8.0.17",
          packages:  ["ping", "git"],
          container: "hoge_container",
          save_dir:  "/path/to/dir",
          overwrite: false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/path/to/dir/Dockerfile",
          <<-STRING,
          FROM mysql:8.0.17

          RUN apt-get -y update
          RUN apt-get -y upgrade
          RUN apt-get -y install ping git

          WORKDIR /root/hoge_container

          STRING
          false
        ),
      },
      {
        desc:         "return dockerfile string with empty packages.",
        mock_setting: {
          image:     "crystallang/crystal",
          packages:  [] of String,
          container: "test_container",
          save_dir:  "/path/to/dir",
          overwrite: false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/path/to/dir/Dockerfile",
          <<-STRING,
          FROM crystallang/crystal

          RUN apt-get -y update
          RUN apt-get -y upgrade

          WORKDIR /root/test_container

          STRING
          false
        ),
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        dummy_cli_options = {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          rc_file:                nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
          desrc:                  false,
        }
        dummy_yaml_str = ""
        options_mock = OptionsMock.new(
          Des::Options::CliOptions.new(dummy_cli_options),
          Des::Options::DesRcFileOptions.new(dummy_yaml_str)
        )

        allow(options_mock).to receive(image).and_return(spec_case["mock_setting"]["image"])
        allow(options_mock).to receive(packages).and_return(spec_case["mock_setting"]["packages"])
        allow(options_mock).to receive(container).and_return(spec_case["mock_setting"]["container"])
        allow(options_mock).to receive(save_dir).and_return(spec_case["mock_setting"]["save_dir"])
        allow(options_mock).to receive(overwrite).and_return(spec_case["mock_setting"]["overwrite"])

        file = Des::SettingFile::Dockerfile.new(options_mock)
        actual = file.build_file_create_info
        expected = spec_case["expected"]

        actual.path.should eq expected.path
        actual.str.should eq expected.str
        actual.overwrite.should eq expected.overwrite
      end
    end
  end
end
