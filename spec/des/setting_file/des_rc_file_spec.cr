require "../../spec_helper"

describe Des::SettingFile::DesrcFile do
  describe "#build_file_create_info" do
    [
      {
        desc:              "return desrc_file string.",
        cli_options_input: {
          image:                  "crystallang/crystal",
          packages:               ["vim", "curl"],
          container:              "test_container",
          save_dir:               "/path/to/dir",
          desrc_path:             "/desrc_path/dir/desrc.yml",
          docker_compose_version: "100",
          web_app:                "false",
          overwrite:              "false",
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
        desc:              "return desrc_file string other parameter version.",
        cli_options_input: {
          image:                  "mysql:8.0.17",
          packages:               ["ping", "git"],
          container:              "hoge_container",
          save_dir:               "/var/tmp",
          desrc_path:             "/desrc_path/dir/desrc.yml",
          docker_compose_version: "20",
          web_app:                "true",
          overwrite:              "true",
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
        desc:              "return desrc_file string when packages is empty.",
        cli_options_input: {
          image:                  "mysql:8.0.17",
          packages:               [] of String,
          container:              "hoge_container",
          save_dir:               "/var/tmp",
          desrc_path:             "/desrc_path/dir/desrc.yml",
          docker_compose_version: "20",
          web_app:                "true",
          overwrite:              "true",
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
        options = Des::Options::Options.new(
          Des::Options::CliOptions.new(spec_case["cli_options_input"]),
          Des::Options::DesrcFileOptions.new("")
        )

        file = Des::SettingFile::DesrcFile.new(options)
        actual = file.build_file_create_info
        expected = spec_case["expected"]

        actual.path.should eq expected.path
        actual.str.should eq expected.str
        actual.overwrite.should eq expected.overwrite
      end
    end
  end
end
