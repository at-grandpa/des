require "../spec_helper"

describe Des::Makefile do
  describe "#create_file" do
    [
      SpecCase.new(
        describe: "create Makefile with rc_file parameter when there is no opts parameters.",
        rc_file_yaml: "
        default_options:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        ",
        cli_options: Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        DOCKER_COMPOSE := docker-compose -f ./docker-compose.yml
        DOCKER_EXEC := docker exec -it
        CONTAINER_NAME := rc_file_container

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


        EXPECT
      ),
      SpecCase.new(
        describe: "create Makefile overwrited 'container' with the opts parameter when opts has an 'container'.",
        rc_file_yaml: "
        default_options:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        ",
        cli_options: Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: "opts_container",
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        DOCKER_COMPOSE := docker-compose -f ./docker-compose.yml
        DOCKER_EXEC := docker exec -it
        CONTAINER_NAME := opts_container

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


        EXPECT
      ),
    ].each do |spec_case|
      it spec_case.describe do
        rc = Rc.from_yaml(spec_case.rc_file_yaml)
        opts = Opts.new(spec_case.cli_options)
        parameters = Parameters.new(rc, opts)
        created_file_path = "#{parameters.save_dir}/Makefile"

        File.delete(created_file_path) if File.exists?(created_file_path)

        Makefile.new(parameters, silent: true).create_file

        File.read(created_file_path).should eq spec_case.expect
        File.delete(created_file_path) if File.exists?(created_file_path)
      end
    end
  end
end
