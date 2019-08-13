require "../../spec_helper"

describe Des::SettingFile::Makefile do
  describe "#to_s" do
    [
      {
        desc:         "return makefile string.",
        mock_setting: {
          container: "test_container",
          save_dir:  "/path/to/dir",
          overwrite: false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/path/to/dir/Makefile",
          <<-STRING,
          DOCKER_COMPOSE := docker-compose -f ./docker-compose.yml
          DOCKER_EXEC := docker exec -it
          CONTAINER_NAME := test_container

          ps:
          	$(DOCKER_COMPOSE) ps

          setup: build up

          build:
          	$(DOCKER_COMPOSE) build

          up:
          	$(DOCKER_COMPOSE) up -d

          clean: stop rm

          stop:
          	$(DOCKER_COMPOSE) stop

          rm:
          	$(DOCKER_COMPOSE) rm -f

          attach:
          	$(DOCKER_EXEC) $(CONTAINER_NAME) /bin/bash

          STRING
          false
        ),
      },
      {
        desc:         "return makefile string other parameter version.",
        mock_setting: {
          container: "hoge_container",
          save_dir:  "/path/to/dir",
          overwrite: false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/path/to/dir/Makefile",
          <<-STRING,
          DOCKER_COMPOSE := docker-compose -f ./docker-compose.yml
          DOCKER_EXEC := docker exec -it
          CONTAINER_NAME := hoge_container

          ps:
          	$(DOCKER_COMPOSE) ps

          setup: build up

          build:
          	$(DOCKER_COMPOSE) build

          up:
          	$(DOCKER_COMPOSE) up -d

          clean: stop rm

          stop:
          	$(DOCKER_COMPOSE) stop

          rm:
          	$(DOCKER_COMPOSE) rm -f

          attach:
          	$(DOCKER_EXEC) $(CONTAINER_NAME) /bin/bash

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

        allow(options_mock).to receive(container).and_return(spec_case["mock_setting"]["container"])
        allow(options_mock).to receive(save_dir).and_return(spec_case["mock_setting"]["save_dir"])
        allow(options_mock).to receive(overwrite).and_return(spec_case["mock_setting"]["overwrite"])

        file = Des::SettingFile::Makefile.new(options_mock)
        actual = file.build_file_create_info
        expected = spec_case["expected"]

        actual.path.should eq expected.path
        actual.str.should eq expected.str
        actual.overwrite.should eq expected.overwrite
      end
    end
  end
end
