require "../spec_helper"

describe Des::DockerCompose do
  describe "#create_file" do
    [
      SpecCase.new(
        describe: "create Dockerfile with rc_file parameter when there is no opts parameters.",
        rc_file_yaml: "
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
          overwrite: false
        ",
        opts_parameters: [] of OptsParameter,
        expect: <<-EXPECT
        version: '2'
        services:
          app:
            build: .
            container_name: rc_file_container
            restart: always
            stdin_open: true
            volumes:
              - .:/root/rc_file_container
            ports:
              - 3000

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited 'container' with the opts parameter when opts has an 'container'.",
        rc_file_yaml: "
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
          overwrite: false
        ",
        opts_parameters: [
          {"container" => "opts_container"},
        ],
        expect: <<-EXPECT
        version: '2'
        services:
          app:
            build: .
            container_name: opts_container
            restart: always
            stdin_open: true
            volumes:
              - .:/root/opts_container
            ports:
              - 3000

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited 'save_dir' with the opts parameter when opts has an 'save_dir'.",
        rc_file_yaml: "
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
          overwrite: false
        ",
        opts_parameters: [
          {"save-dir" => "#{__DIR__}/var/opts_save_dir"},
        ],
        expect: <<-EXPECT
        version: '2'
        services:
          app:
            build: .
            container_name: rc_file_container
            restart: always
            stdin_open: true
            volumes:
              - .:/root/rc_file_container
            ports:
              - 3000

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited 'web_app' with the opts parameter when opts has an 'web_app'.",
        rc_file_yaml: "
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
          overwrite: false
        ",
        opts_parameters: [
          {"web-app" => true},
        ],
        expect: <<-EXPECT
        version: '2'
        services:
          app:
            build: .
            container_name: rc_file_container
            restart: always
            stdin_open: true
            volumes:
              - .:/root/rc_file_container
            ports:
              - 3000
            links:
              - mysql
          mysql:
            image: mysql
            container_name: rc_file_container-mysql
            restart: always
            environment:
              MYSQL_ROOT_PASSWORD: root
            ports:
              - 3306
          nginx:
            image: nginx
            container_name: rc_file_container-nginx
            restart: always
            ports:
              - 80:80
            links:
              - app

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited all parameters with the opts parameter when opts has an all parameters.",
        rc_file_yaml: "
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
          overwrite: false
        ",
        opts_parameters: [
          {"container" => "opts_container"},
          {"save-dir" => "#{__DIR__}/var/opts_save_dir"},
          {"web-app" => true},
        ],
        expect: <<-EXPECT
        version: '2'
        services:
          app:
            build: .
            container_name: opts_container
            restart: always
            stdin_open: true
            volumes:
              - .:/root/opts_container
            ports:
              - 3000
            links:
              - mysql
          mysql:
            image: mysql
            container_name: opts_container-mysql
            restart: always
            environment:
              MYSQL_ROOT_PASSWORD: root
            ports:
              - 3306
          nginx:
            image: nginx
            container_name: opts_container-nginx
            restart: always
            ports:
              - 80:80
            links:
              - app

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
        DockerCompose.new(parameters, silent: true).create_file

        created_file_path = "#{parameters.save_dir}/docker-compose.yml"
        File.read(created_file_path).should eq spec_case.expect
        File.delete(created_file_path)
      end
    end
  end
end
