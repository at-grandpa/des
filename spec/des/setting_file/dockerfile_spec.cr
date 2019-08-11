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
        },
        expected: <<-STRING
        FROM crystallang/crystal

        RUN apt-get -y update
        RUN apt-get -y upgrade
        RUN apt-get -y install vim curl

        WORKDIR /root/test_container

        STRING
      },
      {
        desc:         "return dockerfile string other parameter version.",
        mock_setting: {
          image:     "mysql:8.0.17",
          packages:  ["ping", "git"],
          container: "hoge_container",
        },
        expected: <<-STRING
        FROM mysql:8.0.17

        RUN apt-get -y update
        RUN apt-get -y upgrade
        RUN apt-get -y install ping git

        WORKDIR /root/hoge_container

        STRING
      },
      {
        desc:         "return dockerfile string with empty packages.",
        mock_setting: {
          image:     "crystallang/crystal",
          packages:  [] of String,
          container: "test_container",
        },
        expected: <<-STRING
        FROM crystallang/crystal

        RUN apt-get -y update
        RUN apt-get -y upgrade

        WORKDIR /root/test_container

        STRING
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options_mock = OptionsMock.new(Des::Options::CliOptions.new, Des::Options::DesRcFileOptions.new)
        allow(options_mock).to receive(image).and_return(spec_case["mock_setting"]["image"])
        allow(options_mock).to receive(packages).and_return(spec_case["mock_setting"]["packages"])
        allow(options_mock).to receive(container).and_return(spec_case["mock_setting"]["container"])
        dockerfile = Des::SettingFile::Dockerfile.new(options_mock)
        dockerfile.to_s.should eq spec_case["expected"]
      end
    end
  end
end
