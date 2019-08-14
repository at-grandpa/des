require "../../spec_helper"

describe Des::Options::Options do
  describe "#image" do
    [
      {
        desc:         "when both values exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        "cli_value",
          desrc_file_options_return_value: "desrc_file_value",
        },
        expected: "cli_value",
      },
      {
        desc:         "when cli_value exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        "cli_value",
          desrc_file_options_return_value: nil,
        },
        expected: "cli_value",
      },
      {
        desc:         "when desrc_file_value exist, return desrc_file_value.",
        mock_setting: {
          cli_options_return_value:        nil,
          desrc_file_options_return_value: "desrc_file_value",
        },
        expected: "desrc_file_value",
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
        cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
        allow(cli_options_mock).to receive(image).and_return(spec_case["mock_setting"]["cli_options_return_value"])
        desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
        allow(desrc_file_options_mock).to receive(image).and_return(spec_case["mock_setting"]["desrc_file_options_return_value"])

        options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
        options.image.should eq spec_case["expected"]
      end
    end
    it "when both values not exist, raises an exception." do
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
      cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
      allow(cli_options_mock).to receive(image).and_return(nil)
      desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
      allow(desrc_file_options_mock).to receive(image).and_return(nil)

      options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
      expect_raises(Exception, "image option is not set. See 'des --help'") do
        options.image
      end
    end
  end
  describe "#packages" do
    [
      {
        desc:         "when both values exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        ["cli_value1", "cli_value2"],
          desrc_file_options_return_value: ["desrc_file_value1", "desrc_file_value2"],
        },
        expected: ["cli_value1", "cli_value2"],
      },
      {
        desc:         "when both values exist(desrc_file_options is empty), return cli_value.",
        mock_setting: {
          cli_options_return_value:        ["cli_value1", "cli_value2"],
          desrc_file_options_return_value: [] of String,
        },
        expected: ["cli_value1", "cli_value2"],
      },
      {
        desc:         "when both values exist(cli_options is empty), return desrc_file_value.",
        mock_setting: {
          cli_options_return_value:        [] of String,
          desrc_file_options_return_value: ["desrc_file_value1", "desrc_file_value2"],
        },
        expected: ["desrc_file_value1", "desrc_file_value2"],
      },
      {
        desc:         "when cli_value exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        ["cli_value1", "cli_value2"],
          desrc_file_options_return_value: nil,
        },
        expected: ["cli_value1", "cli_value2"],
      },
      {
        desc:         "when cli_value exist(empty), return cli_value.",
        mock_setting: {
          cli_options_return_value:        [] of String,
          desrc_file_options_return_value: nil,
        },
        expected: [] of String,
      },
      {
        desc:         "when desrc_file_value exist, return desrc_file_value.",
        mock_setting: {
          cli_options_return_value:        nil,
          desrc_file_options_return_value: ["desrc_file_value1", "desrc_file_value2"],
        },
        expected: ["desrc_file_value1", "desrc_file_value2"],
      },
      {
        desc:         "when desrc_file_value exist(empty), return desrc_file_value.",
        mock_setting: {
          cli_options_return_value:        nil,
          desrc_file_options_return_value: [] of String,
        },
        expected: [] of String,
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
        cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
        allow(cli_options_mock).to receive(packages).and_return(spec_case["mock_setting"]["cli_options_return_value"])
        desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
        allow(desrc_file_options_mock).to receive(packages).and_return(spec_case["mock_setting"]["desrc_file_options_return_value"])

        options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
        options.packages.should eq spec_case["expected"]
      end
    end
    it "when both values not exist, raises an exception." do
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
      cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
      allow(cli_options_mock).to receive(packages).and_return(nil)
      desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
      allow(desrc_file_options_mock).to receive(packages).and_return(nil)

      options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
      expect_raises(Exception, "packages option is not set. See 'des --help'") do
        options.packages
      end
    end
  end
  describe "#container" do
    [
      {
        desc:         "when both values exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        "cli_value",
          desrc_file_options_return_value: "desrc_file_value",
        },
        expected: "cli_value",
      },
      {
        desc:         "when cli_value exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        "cli_value",
          desrc_file_options_return_value: nil,
        },
        expected: "cli_value",
      },
      {
        desc:         "when desrc_file_value exist, return desrc_file_value.",
        mock_setting: {
          cli_options_return_value:        nil,
          desrc_file_options_return_value: "desrc_file_value",
        },
        expected: "desrc_file_value",
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
        cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
        allow(cli_options_mock).to receive(container).and_return(spec_case["mock_setting"]["cli_options_return_value"])
        desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
        allow(desrc_file_options_mock).to receive(container).and_return(spec_case["mock_setting"]["desrc_file_options_return_value"])

        options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
        options.container.should eq spec_case["expected"]
      end
    end
    it "when both values not exist, raises an exception." do
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
      cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
      allow(cli_options_mock).to receive(container).and_return(nil)
      desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
      allow(desrc_file_options_mock).to receive(container).and_return(nil)

      options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
      expect_raises(Exception, "container option is not set. See 'des --help'") do
        options.container
      end
    end
  end
  describe "#save_dir" do
    [
      {
        desc:         "when both values exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        "cli_value",
          desrc_file_options_return_value: "desrc_file_value",
        },
        expected: "cli_value",
      },
      {
        desc:         "when cli_value exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        "cli_value",
          desrc_file_options_return_value: nil,
        },
        expected: "cli_value",
      },
      {
        desc:         "when desrc_file_value exist, return desrc_file_value.",
        mock_setting: {
          cli_options_return_value:        nil,
          desrc_file_options_return_value: "desrc_file_value",
        },
        expected: "desrc_file_value",
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
        cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
        allow(cli_options_mock).to receive(save_dir).and_return(spec_case["mock_setting"]["cli_options_return_value"])
        desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
        allow(desrc_file_options_mock).to receive(save_dir).and_return(spec_case["mock_setting"]["desrc_file_options_return_value"])

        options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
        options.save_dir.should eq spec_case["expected"]
      end
    end
    it "when both values not exist, raises an exception." do
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
      cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
      allow(cli_options_mock).to receive(save_dir).and_return(nil)
      desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
      allow(desrc_file_options_mock).to receive(save_dir).and_return(nil)

      options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
      expect_raises(Exception, "save_dir option is not set. See 'des --help'") do
        options.save_dir
      end
    end
  end
  describe "#docker_compose_version" do
    [
      {
        desc:         "when both values exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        "cli_value",
          desrc_file_options_return_value: "desrc_file_value",
        },
        expected: "cli_value",
      },
      {
        desc:         "when cli_value exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        "cli_value",
          desrc_file_options_return_value: nil,
        },
        expected: "cli_value",
      },
      {
        desc:         "when desrc_file_value exist, return desrc_file_value.",
        mock_setting: {
          cli_options_return_value:        nil,
          desrc_file_options_return_value: "desrc_file_value",
        },
        expected: "desrc_file_value",
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
        cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
        allow(cli_options_mock).to receive(docker_compose_version).and_return(spec_case["mock_setting"]["cli_options_return_value"])
        desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
        allow(desrc_file_options_mock).to receive(docker_compose_version).and_return(spec_case["mock_setting"]["desrc_file_options_return_value"])

        options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
        options.docker_compose_version.should eq spec_case["expected"]
      end
    end
    it "when both values not exist, raises an exception." do
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
      cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
      allow(cli_options_mock).to receive(docker_compose_version).and_return(nil)
      desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
      allow(desrc_file_options_mock).to receive(docker_compose_version).and_return(nil)

      options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
      expect_raises(Exception, "docker_compose_version option is not set. See 'des --help'") do
        options.docker_compose_version
      end
    end
  end
  describe "#web_app" do
    [
      {
        desc:         "when both values exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        true,
          desrc_file_options_return_value: false,
        },
        expected: true,
      },
      {
        desc:         "when cli_value exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        true,
          desrc_file_options_return_value: nil,
        },
        expected: true,
      },
      {
        desc:         "when desrc_file_value exist, return desrc_file_value.",
        mock_setting: {
          cli_options_return_value:        nil,
          desrc_file_options_return_value: false,
        },
        expected: false,
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
        cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
        allow(cli_options_mock).to receive(web_app).and_return(spec_case["mock_setting"]["cli_options_return_value"])
        desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
        allow(desrc_file_options_mock).to receive(web_app).and_return(spec_case["mock_setting"]["desrc_file_options_return_value"])

        options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
        options.web_app.should eq spec_case["expected"]
      end
    end
    it "when both values not exist, raises an exception." do
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
      cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
      allow(cli_options_mock).to receive(web_app).and_return(nil)
      desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
      allow(desrc_file_options_mock).to receive(web_app).and_return(nil)

      options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
      expect_raises(Exception, "web_app option is not set. See 'des --help'") do
        options.web_app
      end
    end
  end
  describe "#overwrite" do
    [
      {
        desc:         "when both values exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        true,
          desrc_file_options_return_value: false,
        },
        expected: true,
      },
      {
        desc:         "when cli_value exist, return cli_value.",
        mock_setting: {
          cli_options_return_value:        true,
          desrc_file_options_return_value: nil,
        },
        expected: true,
      },
      {
        desc:         "when desrc_file_value exist, return desrc_file_value.",
        mock_setting: {
          cli_options_return_value:        nil,
          desrc_file_options_return_value: false,
        },
        expected: false,
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
        cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
        allow(cli_options_mock).to receive(overwrite).and_return(spec_case["mock_setting"]["cli_options_return_value"])
        desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
        allow(desrc_file_options_mock).to receive(overwrite).and_return(spec_case["mock_setting"]["desrc_file_options_return_value"])

        options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
        options.overwrite.should eq spec_case["expected"]
      end
    end
    it "when both values not exist, raises an exception." do
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
      cli_options_mock = Des::Options::CliOptions.new(dummy_cli_options)
      allow(cli_options_mock).to receive(overwrite).and_return(nil)
      desrc_file_options_mock = Des::Options::DesrcFileOptions.new("")
      allow(desrc_file_options_mock).to receive(overwrite).and_return(nil)

      options = Des::Options::Options.new(cli_options_mock, desrc_file_options_mock)
      expect_raises(Exception, "overwrite option is not set. See 'des --help'") do
        options.overwrite
      end
    end
  end
end
