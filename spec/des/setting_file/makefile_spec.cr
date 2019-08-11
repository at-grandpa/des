require "../../spec_helper"

describe Des::SettingFile::Makefile do
  describe "#to_s" do
    [
      {
        desc:         "return makefile string.",
        mock_setting: {
          container: "test_container",
        },
        expected: <<-STRING
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
      },
      {
        desc:         "return makefile string other parameter version.",
        mock_setting: {
          container: "hoge_container",
        },
        expected: <<-STRING
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
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options_mock = OptionsMock.new(Des::Options::CliOptions.new, Des::Options::DesRcFileOptions.new)
        allow(options_mock).to receive(container).and_return(spec_case["mock_setting"]["container"])
        makefile = Des::SettingFile::Makefile.new(options_mock)
        makefile.to_s.should eq spec_case["expected"]
      end
    end
  end
end
