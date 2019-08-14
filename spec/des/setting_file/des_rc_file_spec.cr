require "../../spec_helper"

describe Des::SettingFile::DesrcFile do
  describe "#build_file_create_info" do
    [
      {
        desc:         "return desrc_file string.",
        mock_setting: {
          image:                  "crystallang/crystal",
          packages:               ["vim", "curl"],
          container:              "test_container",
          save_dir:               "/path/to/dir",
          desrc_path:             "/desrc_path/dir/desrc.yml",
          docker_compose_version: "100",
          web_app:                false,
          overwrite:              false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/desrc_path/dir/desrc.yml",
          <<-STRING,
          default_options:
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
          false
        ),
      },
      {
        desc:         "return desrc_file string other parameter version.",
        mock_setting: {
          image:                  "mysql:8.0.17",
          packages:               ["ping", "git"],
          container:              "hoge_container",
          save_dir:               "/var/tmp",
          desrc_path:             "/desrc_path/dir/desrc.yml",
          docker_compose_version: "20",
          web_app:                true,
          overwrite:              true,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/desrc_path/dir/desrc.yml",
          <<-STRING,
          default_options:
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
          true
        ),
      },
      {
        desc:         "return desrc_file string when packages is empty.",
        mock_setting: {
          image:                  "mysql:8.0.17",
          packages:               [] of String,
          container:              "hoge_container",
          save_dir:               "/var/tmp",
          desrc_path:             "/desrc_path/dir/desrc.yml",
          docker_compose_version: "20",
          web_app:                true,
          overwrite:              true,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/desrc_path/dir/desrc.yml",
          <<-STRING,
          default_options:
            image: mysql:8.0.17
            packages: []
            container: hoge_container
            save_dir: /var/tmp
            docker_compose_version: 20
            web_app: true
            overwrite: true

          STRING
          true
        ),
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        dummy_cli_options = {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          desrc_path:             nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }
        dummy_yaml_str = ""
        options_mock = OptionsMock.new(
          Des::Options::CliOptions.new(dummy_cli_options),
          Des::Options::DesrcFileOptions.new(dummy_yaml_str)
        )

        allow(options_mock).to receive(image).and_return(spec_case["mock_setting"]["image"])
        allow(options_mock).to receive(packages).and_return(spec_case["mock_setting"]["packages"])
        allow(options_mock).to receive(container).and_return(spec_case["mock_setting"]["container"])
        allow(options_mock).to receive(save_dir).and_return(spec_case["mock_setting"]["save_dir"])
        allow(options_mock).to receive(desrc_path).and_return(spec_case["mock_setting"]["desrc_path"])
        allow(options_mock).to receive(docker_compose_version).and_return(spec_case["mock_setting"]["docker_compose_version"])
        allow(options_mock).to receive(web_app).and_return(spec_case["mock_setting"]["web_app"])
        allow(options_mock).to receive(overwrite).and_return(spec_case["mock_setting"]["overwrite"])

        file = Des::SettingFile::DesrcFile.new(options_mock)
        actual = file.build_file_create_info
        expected = spec_case["expected"]

        actual.path.should eq expected.path
        actual.str.should eq expected.str
        actual.overwrite.should eq expected.overwrite
      end
    end
  end
end
