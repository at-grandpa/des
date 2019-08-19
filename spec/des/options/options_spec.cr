require "../../spec_helper"

describe Des::Options::Options do
  describe "#new" do
    [
      {
        desc:        "when cli_options is nil, return desrc_file_options.",
        cli_options: Des::Options::CliOptions.new({
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        desrc_file_options: Des::Options::DesrcFileOptions.from_yaml(
          <<-STRING
          default_options:
            image: desrc_file_image
            packages:
              - desrc_file_package1
              - desrc_file_package2
            container: desrc_file_container
            save_dir: /desrc_file/path/to/dir
            docker_compose_version: 10
            web_app: true
            overwrite: true
          STRING
        ),
        expected: {
          image:                  "desrc_file_image",
          packages:               ["desrc_file_package1", "desrc_file_package2"],
          container:              "desrc_file_container",
          save_dir:               "/desrc_file/path/to/dir",
          docker_compose_version: "10",
          web_app:                true,
          overwrite:              true,
        },
      },
      {
        desc:        "when cli_options exists, return cli_options value.",
        cli_options: Des::Options::CliOptions.new({
          image:                  "cli_image",
          packages:               ["cli_package1"],
          container:              nil,
          save_dir:               nil,
          docker_compose_version: "3",
          web_app:                "false",
          overwrite:              nil,
        }),
        desrc_file_options: Des::Options::DesrcFileOptions.from_yaml(
          <<-STRING
          default_options:
            image: desrc_file_image
            packages:
              - desrc_file_package1
              - desrc_file_package2
            container: desrc_file_container
            save_dir: /desrc_file/path/to/dir
            docker_compose_version: 10
            web_app: true
            overwrite: true
          STRING
        ),
        expected: {
          image:                  "cli_image",
          packages:               ["cli_package1"],
          container:              "desrc_file_container",
          save_dir:               "/desrc_file/path/to/dir",
          docker_compose_version: "3",
          web_app:                false,
          overwrite:              true,
        },
      },
      {
        desc:        "when both options are nil, return default value.",
        cli_options: Des::Options::CliOptions.new({
          image:                  nil,
          packages:               ["cli_package1"],
          container:              nil,
          save_dir:               nil,
          docker_compose_version: "3",
          web_app:                "true",
          overwrite:              nil,
        }),
        desrc_file_options: Des::Options::DesrcFileOptions.from_yaml(
          <<-STRING
          default_options:
            packages:
              - desrc_file_package1
              - desrc_file_package2
            save_dir: /desrc_file/path/to/dir
            docker_compose_version: 10
            web_app: true
          STRING
        ),
        expected: {
          image:                  "ubuntu:18.04",
          packages:               ["cli_package1"],
          container:              "my_container",
          save_dir:               "/desrc_file/path/to/dir",
          docker_compose_version: "3",
          web_app:                true,
          overwrite:              false,
        },
      },
      {
        desc:        "when both options are all nil, return default value.",
        cli_options: Des::Options::CliOptions.new({
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        desrc_file_options: Des::Options::DesrcFileOptions.from_yaml(
          <<-STRING
          STRING
        ),
        expected: {
          image:                  "ubuntu:18.04",
          packages:               [] of String,
          container:              "my_container",
          save_dir:               ".",
          docker_compose_version: "3",
          web_app:                false,
          overwrite:              false,
        },
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        des_options = ::Des::Options::Options.new(spec_case["cli_options"], spec_case["desrc_file_options"])
        des_options.image.should eq spec_case["expected"]["image"]
        des_options.packages.should eq spec_case["expected"]["packages"]
        des_options.container.should eq spec_case["expected"]["container"]
        des_options.save_dir.should eq spec_case["expected"]["save_dir"]
        des_options.docker_compose_version.should eq spec_case["expected"]["docker_compose_version"]
        des_options.web_app.should eq spec_case["expected"]["web_app"]
        des_options.overwrite.should eq spec_case["expected"]["overwrite"]
      end
    end
  end
  describe "exceptions" do
    [
      {
        desc:        "raises an Exception, when image option is not set.",
        cli_options: Des::Options::CliOptions.new({
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }),
        desrc_file_options: Des::Options::DesrcFileOptions.from_yaml(
          <<-STRING
          STRING
        ),
        default_desrc_yaml_string: <<-STRING,
        default_options:
        STRING
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        des_options = ::Des::Options::Options.new(spec_case["cli_options"], spec_case["desrc_file_options"], spec_case["default_desrc_yaml_string"])
        expect_raises(Des::DesException, "image option is not set. See 'des --help'") do
          des_options.image
        end

        # No Exception occurs because the package option is never nil in cli _ options.
        #
        # expect_raises(Des::DesException, "packages option is not set. See 'des --help'") do
        #   des_options.packages
        # end

        expect_raises(Des::DesException, "container option is not set. See 'des --help'") do
          des_options.container
        end
        expect_raises(Des::DesException, "save_dir option is not set. See 'des --help'") do
          des_options.save_dir
        end
        expect_raises(Des::DesException, "docker_compose_version option is not set. See 'des --help'") do
          des_options.docker_compose_version
        end
        expect_raises(Des::DesException, "web_app option is not set. See 'des --help'") do
          des_options.web_app
        end
        expect_raises(Des::DesException, "overwrite option is not set. See 'des --help'") do
          des_options.overwrite
        end
      end
    end
  end
end
