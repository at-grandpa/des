require "../../spec_helper"

describe Des::SettingFile::DesRcFile do
  describe "#to_s" do
    [
      {
        desc:         "return des_rc_file string.",
        mock_setting: {
          image:                  "crystallang/crystal",
          packages:               ["vim", "curl"],
          container:              "test_container",
          save_dir:               "/path/to/dir",
          docker_compose_version: "100",
          web_app:                false,
          overwrite:              false,
        },
        expected: <<-STRING
        default_param:
          image: crystallang/crystal
          packages:
            - vim
            - curl
          container: test_container
          save_dir: /path/to/dir
          docker_compose_version: 100
          web_app: false
          overwrite: false

        STRING
      },
      {
        desc:         "return des_rc_file string other parameter version.",
        mock_setting: {
          image:                  "mysql:8.0.17",
          packages:               ["ping", "git"],
          container:              "hoge_container",
          save_dir:               "/var/tmp",
          docker_compose_version: "20",
          web_app:                true,
          overwrite:              true,
        },
        expected: <<-STRING
        default_param:
          image: mysql:8.0.17
          packages:
            - ping
            - git
          container: hoge_container
          save_dir: /var/tmp
          docker_compose_version: 20
          web_app: true
          overwrite: true

        STRING
      },
      {
        desc:         "return des_rc_file string when packages is empty.",
        mock_setting: {
          image:                  "mysql:8.0.17",
          packages:               [] of String,
          container:              "hoge_container",
          save_dir:               "/var/tmp",
          docker_compose_version: "20",
          web_app:                true,
          overwrite:              true,
        },
        expected: <<-STRING
        default_param:
          image: mysql:8.0.17
          packages: []
          container: hoge_container
          save_dir: /var/tmp
          docker_compose_version: 20
          web_app: true
          overwrite: true

        STRING
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options_mock = OptionsMock.new(Des::Options::CliOptions.new, Des::Options::DesRcFileOptions.new)
        allow(options_mock).to receive(image).and_return(spec_case["mock_setting"]["image"])
        allow(options_mock).to receive(packages).and_return(spec_case["mock_setting"]["packages"])
        allow(options_mock).to receive(container).and_return(spec_case["mock_setting"]["container"])
        allow(options_mock).to receive(save_dir).and_return(spec_case["mock_setting"]["save_dir"])
        allow(options_mock).to receive(docker_compose_version).and_return(spec_case["mock_setting"]["docker_compose_version"])
        allow(options_mock).to receive(web_app).and_return(spec_case["mock_setting"]["web_app"])
        allow(options_mock).to receive(overwrite).and_return(spec_case["mock_setting"]["overwrite"])
        des_rc_file = Des::SettingFile::DesRcFile.new(options_mock)
        des_rc_file.to_s.should eq spec_case["expected"]
      end
    end
  end
end
