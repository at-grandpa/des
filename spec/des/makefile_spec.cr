require "../spec_helper"

describe Des::Makefile do
  describe "#create_file" do
    [
      SpecCase.new(
        describe: "create Makefile with rc_file parameter when there is no opts parameters.",
        rc_file_yaml: "
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
        ",
        opts_parameters: [] of OptsParameter,
        expect: <<-EXPECT
        DOCKER_COMPOSE := docker-compose -f ./docker-compose.yml
        DOCKER_EXEC := docker exec -it
        CONTAINER_NAME := rc_file_container

        ps:
        	$(DOCKER_COMPOSE) ps

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
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
        ",
        opts_parameters: [
          {"container" => "opts_container"},
        ],
        expect: <<-EXPECT
        DOCKER_COMPOSE := docker-compose -f ./docker-compose.yml
        DOCKER_EXEC := docker exec -it
        CONTAINER_NAME := opts_container

        ps:
        	$(DOCKER_COMPOSE) ps

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
        rc = Rc.new(spec_case.rc_file_yaml)

        input_opts = Clim::Options::Values.new
        spec_case.opts_parameters.each do |parameter|
          input_opts.merge!(parameter)
        end
        opts = Opts.new(input_opts)

        parameters = Parameters.new(rc, opts)
        Makefile.new(parameters, silent: true).create_file

        created_file_path = "#{parameters.save_dir}/Makefile"
        File.read(created_file_path).should eq spec_case.expect
        File.delete(created_file_path)
      end
    end
  end
end
