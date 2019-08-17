require "../../spec_helper"

def delete_dir(path)
  if Dir.exists?(path)
    Dir.cd(path)
    Dir.glob("*").each do |file|
      full_path = "#{path}/#{file}"
      File.delete(full_path) if File.exists?(full_path)
    end
    Dir.rmdir(path)
  end
end

describe Des::Cli::Executer do
  describe "#create all" do
    [
      {
        desc:        "create all file.",
        cli_options: {
          image:                  "test_image",
          packages:               ["vim", "ping"],
          container:              "test_container",
          save_dir:               "#{__DIR__}/var/spec_dir",
          docker_compose_version: "3",
          web_app:                "false",
          overwrite:              "false",
        },
        files_to_create_before_testing: [] of NamedTuple(path: String, string: String),
        desrc_path_str:                 <<-STRING,
        STRING
        prompt_input_str: "",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/Dockerfile",
              string: <<-STRING,
              \\AFROM test_image

              RUN apt-get -y update
              RUN apt-get -y upgrade
              RUN apt-get -y install vim ping

              WORKDIR \\/root\\/test_container
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/Makefile",
              string: <<-STRING,
              \\ADOCKER_COMPOSE := docker-compose -f \\.\\/docker-compose\\.yml
              DOCKER_EXEC := docker exec -it
              CONTAINER_NAME := test_container

              ps:
              	\\$\\(DOCKER_COMPOSE\\) ps

              setup: build up

              build:
              	\\$\\(DOCKER_COMPOSE\\) build

              up:
              	\\$\\(DOCKER_COMPOSE\\) up -d

              clean: stop rm

              stop:
              	\\$\\(DOCKER_COMPOSE\\) stop

              rm:
              	\\$\\(DOCKER_COMPOSE\\) rm -f

              attach:
              	\\$\\(DOCKER_EXEC\\) \\$\\(CONTAINER_NAME\\) \\/bin\\/bash
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/docker-compose.yml",
              string: <<-STRING,
              \\Aversion: '3'
              services:
                app:
                  build: \\.
                  container_name: test_container
                  restart: always
                  stdin_open: true
                  volumes:
                    - \\.:/root/test_container
                  ports:
                    - 3000
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              \\Adefault_options:
                image: test_image
                packages:
                  - vim
                  - ping
                container: test_container
                save_dir: \\/.+?\\/var\\/spec_dir
                docker_compose_version: 3
                web_app: false
                overwrite: false
              \\z
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A\\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/desrc.yml
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Dockerfile
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Makefile
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/docker-compose.yml
          \\z
          STRING
        },
      },
      {
        desc:        "when an desrc_path exists, it is not created.",
        cli_options: {
          image:                  "test_image",
          packages:               ["vim", "ping"],
          container:              "test_container",
          save_dir:               "#{__DIR__}/var/spec_dir",
          docker_compose_version: "3",
          web_app:                "false",
          overwrite:              "false",
        },
        files_to_create_before_testing: [
          {
            path:   "#{__DIR__}/var/spec_dir/desrc.yml",
            string: "hoge",
          },
        ],
        desrc_path_str: <<-STRING,
        STRING
        prompt_input_str: "",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/Dockerfile",
              string: <<-STRING,
              \\AFROM test_image

              RUN apt-get -y update
              RUN apt-get -y upgrade
              RUN apt-get -y install vim ping

              WORKDIR \\/root\\/test_container
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/Makefile",
              string: <<-STRING,
              \\ADOCKER_COMPOSE := docker-compose -f \\.\\/docker-compose\\.yml
              DOCKER_EXEC := docker exec -it
              CONTAINER_NAME := test_container

              ps:
              	\\$\\(DOCKER_COMPOSE\\) ps

              setup: build up

              build:
              	\\$\\(DOCKER_COMPOSE\\) build

              up:
              	\\$\\(DOCKER_COMPOSE\\) up -d

              clean: stop rm

              stop:
              	\\$\\(DOCKER_COMPOSE\\) stop

              rm:
              	\\$\\(DOCKER_COMPOSE\\) rm -f

              attach:
              	\\$\\(DOCKER_EXEC\\) \\$\\(CONTAINER_NAME\\) \\/bin\\/bash
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/docker-compose.yml",
              string: <<-STRING,
              \\Aversion: '3'
              services:
                app:
                  build: \\.
                  container_name: test_container
                  restart: always
                  stdin_open: true
                  volumes:
                    - \\.:/root/test_container
                  ports:
                    - 3000
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              \\Ahoge\\z
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A\\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Dockerfile
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Makefile
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/docker-compose.yml
          \\z
          STRING
        },
      },
      {
        desc:        "if the setting file exists, you are prompted to overwrite it by saying yes.",
        cli_options: {
          image:                  "test_image",
          packages:               ["vim", "ping"],
          container:              "test_container",
          save_dir:               "#{__DIR__}/var/spec_dir",
          docker_compose_version: "3",
          web_app:                "false",
          overwrite:              "false",
        },
        files_to_create_before_testing: [
          {
            path:   "#{__DIR__}/var/spec_dir/desrc.yml",
            string: "",
          },
          {
            path:   "#{__DIR__}/var/spec_dir/Dockerfile",
            string: "Dockerfile hoge",
          },
          {
            path:   "#{__DIR__}/var/spec_dir/Makefile",
            string: "Default Makefile",
          },
        ],
        desrc_path_str: <<-STRING,
        STRING
        prompt_input_str: "y\nn",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/Dockerfile",
              string: <<-STRING,
              \\AFROM test_image

              RUN apt-get -y update
              RUN apt-get -y upgrade
              RUN apt-get -y install vim ping

              WORKDIR \\/root\\/test_container
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/Makefile",
              string: <<-STRING,
              \\ADefault Makefile\\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/docker-compose.yml",
              string: <<-STRING,
              \\Aversion: '3'
              services:
                app:
                  build: \\.
                  container_name: test_container
                  restart: always
                  stdin_open: true
                  volumes:
                    - \\.:/root/test_container
                  ports:
                    - 3000
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A
          \\/.+?\\/var\\/spec_dir\\/Dockerfile
          Overwrite\\? \\(y or n\\) > \\e\\[92mOverwrite\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Dockerfile

          \\/.+?\\/var\\/spec_dir\\/Makefile
          Overwrite\\? \\(y or n\\) > \\e\\[93mDid not overwrite.\\e\\[0m
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/docker-compose.yml
          \\z
          STRING
        },
      },
      {
        desc:        "if the setting file exists and with overwrite flag, their are overwrited without prompt.",
        cli_options: {
          image:                  "test_image",
          packages:               ["vim", "ping"],
          container:              "test_container",
          save_dir:               "#{__DIR__}/var/spec_dir",
          docker_compose_version: "3",
          web_app:                "false",
          overwrite:              "true",
        },
        files_to_create_before_testing: [
          {
            path:   "#{__DIR__}/var/spec_dir/desrc.yml",
            string: "",
          },
          {
            path:   "#{__DIR__}/var/spec_dir/Dockerfile",
            string: "Dockerfile hoge",
          },
          {
            path:   "#{__DIR__}/var/spec_dir/Makefile",
            string: "Default Makefile",
          },
        ],
        desrc_path_str: <<-STRING,
        STRING
        prompt_input_str: "",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/Dockerfile",
              string: <<-STRING,
              \\AFROM test_image

              RUN apt-get -y update
              RUN apt-get -y upgrade
              RUN apt-get -y install vim ping

              WORKDIR \\/root\\/test_container
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/Makefile",
              string: <<-STRING,
              \\ADOCKER_COMPOSE := docker-compose -f \\.\\/docker-compose\\.yml
              DOCKER_EXEC := docker exec -it
              CONTAINER_NAME := test_container

              ps:
              	\\$\\(DOCKER_COMPOSE\\) ps

              setup: build up

              build:
              	\\$\\(DOCKER_COMPOSE\\) build

              up:
              	\\$\\(DOCKER_COMPOSE\\) up -d

              clean: stop rm

              stop:
              	\\$\\(DOCKER_COMPOSE\\) stop

              rm:
              	\\$\\(DOCKER_COMPOSE\\) rm -f

              attach:
              	\\$\\(DOCKER_EXEC\\) \\$\\(CONTAINER_NAME\\) \\/bin\\/bash
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/docker-compose.yml",
              string: <<-STRING,
              \\Aversion: '3'
              services:
                app:
                  build: \\.
                  container_name: test_container
                  restart: always
                  stdin_open: true
                  volumes:
                    - \\.:/root/test_container
                  ports:
                    - 3000
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A\\e\\[92mOverwrite\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Dockerfile
          \\e\\[92mOverwrite\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Makefile
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/docker-compose.yml
          \\z
          STRING
        },
      },
      {
        desc:        "when web_app flag is true, create web app version files.",
        cli_options: {
          image:                  "test_image",
          packages:               ["vim", "ping"],
          container:              "test_container",
          save_dir:               "#{__DIR__}/var/spec_dir",
          docker_compose_version: "3",
          web_app:                "true",
          overwrite:              "false",
        },
        files_to_create_before_testing: [
          {
            path:   "#{__DIR__}/var/spec_dir/desrc.yml",
            string: "",
          },
        ],
        desrc_path_str: <<-STRING,
        STRING
        prompt_input_str: "",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/Dockerfile",
              string: <<-STRING,
              \\AFROM test_image

              RUN apt-get -y update
              RUN apt-get -y upgrade
              RUN apt-get -y install vim ping

              WORKDIR \\/root\\/test_container
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/Makefile",
              string: <<-STRING,
              \\ADOCKER_COMPOSE := docker-compose -f \\.\\/docker-compose\\.yml
              DOCKER_EXEC := docker exec -it
              CONTAINER_NAME := test_container

              ps:
              	\\$\\(DOCKER_COMPOSE\\) ps

              setup: build up

              build:
              	\\$\\(DOCKER_COMPOSE\\) build

              up:
              	\\$\\(DOCKER_COMPOSE\\) up -d

              clean: stop rm

              stop:
              	\\$\\(DOCKER_COMPOSE\\) stop

              rm:
              	\\$\\(DOCKER_COMPOSE\\) rm -f

              attach:
              	\\$\\(DOCKER_EXEC\\) \\$\\(CONTAINER_NAME\\) \\/bin\\/bash
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/docker-compose.yml",
              string: <<-STRING,
              \\Aversion: '3'
              services:
                app:
                  build: .
                  container_name: test_container
                  restart: always
                  stdin_open: true
                  volumes:
                    - .:/root/test_container
                  ports:
                    - 3000
                  links:
                    - mysql
                mysql:
                  image: mysql
                  container_name: test_container-mysql
                  restart: always
                  environment:
                    MYSQL_ROOT_PASSWORD: root
                  ports:
                    - 3306
                nginx:
                  image: nginx
                  container_name: test_container-nginx
                  restart: always
                  volumes:
                    - ./nginx.conf:/etc/nginx/nginx.conf
                  ports:
                    - 80:80
                  links:
                    - app
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/nginx.conf",
              string: <<-STRING,

              user  nginx;
              worker_processes  1;

              error_log  \\/var\\/log\\/nginx\\/error\\.log warn;
              pid        \\/var\\/run\\/nginx\\.pid;

              events \\{
                  worker_connections  1024;
              \\}

              http \\{
                  include       \\/etc\\/nginx\\/mime\\.types;
                  default_type  application\\/octet-stream;

                  log_format  main  '\\$remote_addr - \\$remote_user \\[\\$time_local\\] "\\$request" '
                                    '\\$status \\$body_bytes_sent "\\$http_referer" '
                                    '"\\$http_user_agent" "\\$http_x_forwarded_for"';

                  access_log  \\/var\\/log\\/nginx\\/access\\.log  main;

                  sendfile        on;
                  #tcp_nopush     on;

                  keepalive_timeout  65;

                  #gzip  on;

                  server \\{
                      listen 80;

                      location \\/ \\{
                          proxy_pass http:\\/\\/app:3000\\/;
                      \\}
                  \\}

                  include \\/etc\\/nginx\\/conf\\.d\\/\\*\\.conf;
              \\}

              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A\\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Dockerfile
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Makefile
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/docker-compose.yml
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/nginx.conf
          \\z
          STRING
        },
      },
      {
        desc:        "if a desrc.yml exists, the value of the desrc.yml is used for options that are not specified in cli_options.",
        cli_options: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        },
        files_to_create_before_testing: [] of NamedTuple(path: String, string: String),
        desrc_path_str:                 <<-STRING,
        default_options:
          image: desrc_image
          packages:
            - desrc_package1
            - desrc_package2
          container: desrc_container
          save_dir: #{__DIR__}/var/spec_dir
          docker_compose_version: 99
          web_app: true
          overwrite: true
        STRING
        prompt_input_str: "",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/Dockerfile",
              string: <<-STRING,
              \\AFROM desrc_image

              RUN apt-get -y update
              RUN apt-get -y upgrade
              RUN apt-get -y install desrc_package1 desrc_package2

              WORKDIR \\/root\\/desrc_container
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/Makefile",
              string: <<-STRING,
              \\ADOCKER_COMPOSE := docker-compose -f \\.\\/docker-compose\\.yml
              DOCKER_EXEC := docker exec -it
              CONTAINER_NAME := desrc_container

              ps:
              	\\$\\(DOCKER_COMPOSE\\) ps

              setup: build up

              build:
              	\\$\\(DOCKER_COMPOSE\\) build

              up:
              	\\$\\(DOCKER_COMPOSE\\) up -d

              clean: stop rm

              stop:
              	\\$\\(DOCKER_COMPOSE\\) stop

              rm:
              	\\$\\(DOCKER_COMPOSE\\) rm -f

              attach:
              	\\$\\(DOCKER_EXEC\\) \\$\\(CONTAINER_NAME\\) \\/bin\\/bash
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/docker-compose.yml",
              string: <<-STRING,
              \\Aversion: '99'
              services:
                app:
                  build: .
                  container_name: desrc_container
                  restart: always
                  stdin_open: true
                  volumes:
                    - .:/root/desrc_container
                  ports:
                    - 3000
                  links:
                    - mysql
                mysql:
                  image: mysql
                  container_name: desrc_container-mysql
                  restart: always
                  environment:
                    MYSQL_ROOT_PASSWORD: root
                  ports:
                    - 3306
                nginx:
                  image: nginx
                  container_name: desrc_container-nginx
                  restart: always
                  volumes:
                    - ./nginx.conf:/etc/nginx/nginx.conf
                  ports:
                    - 80:80
                  links:
                    - app
              \\z
              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/nginx.conf",
              string: <<-STRING,

              user  nginx;
              worker_processes  1;

              error_log  \\/var\\/log\\/nginx\\/error\\.log warn;
              pid        \\/var\\/run\\/nginx\\.pid;

              events \\{
                  worker_connections  1024;
              \\}

              http \\{
                  include       \\/etc\\/nginx\\/mime\\.types;
                  default_type  application\\/octet-stream;

                  log_format  main  '\\$remote_addr - \\$remote_user \\[\\$time_local\\] "\\$request" '
                                    '\\$status \\$body_bytes_sent "\\$http_referer" '
                                    '"\\$http_user_agent" "\\$http_x_forwarded_for"';

                  access_log  \\/var\\/log\\/nginx\\/access\\.log  main;

                  sendfile        on;
                  #tcp_nopush     on;

                  keepalive_timeout  65;

                  #gzip  on;

                  server \\{
                      listen 80;

                      location \\/ \\{
                          proxy_pass http:\\/\\/app:3000\\/;
                      \\}
                  \\}

                  include \\/etc\\/nginx\\/conf\\.d\\/\\*\\.conf;
              \\}

              STRING
            },
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              default_options:
                image: desrc_image
                packages:
                  - desrc_package1
                  - desrc_package2
                container: desrc_container
                save_dir: #{__DIR__}/var/spec_dir
                docker_compose_version: 99
                web_app: true
                overwrite: true

              STRING
            },
          ],
          output_message: <<-STRING,
          \\A\\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/desrc.yml
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Dockerfile
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/Makefile
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/docker-compose.yml
          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/nginx.conf
          \\z
          STRING
        },
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        des_options = ::Des::Options::Options.new(
          Des::Options::CliOptions.new(spec_case["cli_options"]),
          Des::Options::DesrcFileOptions.from_yaml(spec_case["desrc_path_str"])
        )

        writer = IO::Memory.new
        reader = IO::Memory.new spec_case["prompt_input_str"]
        file_creator = Des::Cli::FileCreator.new(writer, reader)

        desrc_file = Des::SettingFile::DesrcFile.new(des_options, "#{des_options.save_dir}/desrc.yml")
        dockerfile = Des::SettingFile::Dockerfile.new(des_options)
        makefile = Des::SettingFile::Makefile.new(des_options)
        docker_compose = Des::SettingFile::DockerCompose.new(des_options)
        nginx_conf = Des::SettingFile::NginxConf.new(des_options)

        delete_dir(des_options.save_dir)
        Dir.mkdir(des_options.save_dir) unless Dir.exists?(des_options.save_dir)

        spec_case["files_to_create_before_testing"].each do |file|
          File.write(file[:path], file[:string])
        end

        executer = Des::Cli::Executer.new(file_creator)
        executer.create(des_options, desrc_file, dockerfile, makefile, docker_compose, nginx_conf)

        spec_case["expected"]["file_expected_list"].each do |file|
          File.read(file["path"]).should match /#{file["string"]}/
        end

        delete_dir(des_options.save_dir)
        writer.to_s.should match /#{spec_case["expected"]["output_message"]}/
      end
    end
  end
  describe "#create desrc.yml" do
    [
      {
        desc:        "if desrc.yml is not exist and cli_options is nil, create desrc.yml.",
        cli_options: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        },
        files_to_create_before_testing: {
          path:   nil,
          string: nil,
        },
        prompt_input_str: "",
        spec_dir: "#{__DIR__}/var/spec_dir",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              \\Adefault_options:
                image: ubuntu:18.04
                packages: \\[\\]
                container: my_container
                save_dir: .
                docker_compose_version: 3
                web_app: false
                overwrite: false
              \\z
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A
          path: \\/.+?\\/var\\/spec_dir\\/desrc.yml

          default_options:
            image: ubuntu:18.04
            packages: \\[\\]
            container: my_container
            save_dir: \\.
            docker_compose_version: 3
            web_app: false
            overwrite: false

          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/desrc.yml
          \\z
          STRING
        },
      },
      {
        desc:        "if desrc.yml is not exist and cli_options specified, overwritten desrc.yml by cli_options.",
        cli_options: {
          image:                  "cli_options_image",
          packages:               ["cli_options_package1"],
          container:              "cli_options_container",
          save_dir:               "/path/to/cli_options_dir",
          docker_compose_version: "999",
          web_app:                "true",
          overwrite:              "true",
        },
        files_to_create_before_testing: {
          path:   nil,
          string: nil,
        },
        prompt_input_str: "",
        spec_dir: "#{__DIR__}/var/spec_dir",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              \\Adefault_options:
                image: cli_options_image
                packages:
                  - cli_options_package1
                container: cli_options_container
                save_dir: \\/path\\/to\\/cli_options_dir
                docker_compose_version: 999
                web_app: true
                overwrite: true
              \\z
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A
          path: \\/.+?\\/var\\/spec_dir\\/desrc.yml

          default_options:
            image: cli_options_image
            packages:
              - cli_options_package1
            container: cli_options_container
            save_dir: \\/path\\/to\\/cli_options_dir
            docker_compose_version: 999
            web_app: true
            overwrite: true

          \\e\\[92mCreate\\e\\[0m \\/.+?\\/var\\/spec_dir\\/desrc.yml
          \\z
          STRING
        },
      },
      {
        desc:        "if desrc.yml missing any option is exist, overwritten desrc.yml by default.",
        cli_options: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        },
        files_to_create_before_testing: {
          path:   "#{__DIR__}/var/spec_dir/desrc.yml",
          string:                 <<-STRING,
          default_options:
            packages:
              - desrc_options_package1
            container: desrc_options_container
            web_app: true
          STRING
        },
        prompt_input_str: "y",
        spec_dir: "#{__DIR__}/var/spec_dir",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              \\Adefault_options:
                image: ubuntu:18.04
                packages:
                  - desrc_options_package1
                container: desrc_options_container
                save_dir: .
                docker_compose_version: 3
                web_app: true
                overwrite: false
              \\z
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A
          path: \\/.+?\\/var\\/spec_dir\\/desrc.yml

          default_options:
            image: ubuntu:18.04
            packages:
              - desrc_options_package1
            container: desrc_options_container
            save_dir: .
            docker_compose_version: 3
            web_app: true
            overwrite: false


          \\/.+?\\/var\\/spec_dir\\/desrc.yml
          Overwrite\\? \\(y or n\\) > \\e\\[92mOverwrite\\e\\[0m \\/.+?\\/var\\/spec_dir\\/desrc.yml
          \\z
          STRING
        },
      },
      {
        desc:        "if desrc.yml is not overwritten, the file is not overwritten.",
        cli_options: {
          image:                  nil,
          packages:               [] of String,
          container:              nil,
          save_dir:               nil,
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        },
        files_to_create_before_testing: {
          path:   "#{__DIR__}/var/spec_dir/desrc.yml",
          string:                 <<-STRING,
          default_options:
            packages:
              - desrc_options_package1
            container: desrc_options_container
            web_app: true
          STRING
        },
        prompt_input_str: "n",
        spec_dir: "#{__DIR__}/var/spec_dir",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              \\Adefault_options:
                packages:
                  - desrc_options_package1
                container: desrc_options_container
                web_app: true\\z
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A
          path: \\/.+?\\/var\\/spec_dir\\/desrc.yml

          default_options:
            image: ubuntu:18.04
            packages:
              - desrc_options_package1
            container: desrc_options_container
            save_dir: .
            docker_compose_version: 3
            web_app: true
            overwrite: false


          \\/.+?\\/var\\/spec_dir\\/desrc.yml
          Overwrite\\? \\(y or n\\) > \\e\\[93mDid not overwrite.\\e\\[0m
          \\z
          STRING
        },
      },
      {
        desc:        "mix options overwrite.",
        cli_options: {
          image:                  "cli_image",
          packages:               [] of String,
          container:              nil,
          save_dir:               "/path/to/cli_options_dir",
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              "true",
        },
        files_to_create_before_testing: {
          path:   "#{__DIR__}/var/spec_dir/desrc.yml",
          string:                 <<-STRING,
          default_options:
            packages:
              - desrc_options_package1
            docker_compose_version: 999
          STRING
        },
        prompt_input_str: "y",
        spec_dir: "#{__DIR__}/var/spec_dir",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              \\Adefault_options:
                image: cli_image
                packages:
                  - desrc_options_package1
                container: my_container
                save_dir: \\/path\\/to\\/cli_options_dir
                docker_compose_version: 999
                web_app: false
                overwrite: true
              \\z
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A
          path: \\/.+?\\/var\\/spec_dir\\/desrc.yml

          default_options:
            image: cli_image
            packages:
              - desrc_options_package1
            container: my_container
            save_dir: \\/path\\/to\\/cli_options_dir
            docker_compose_version: 999
            web_app: false
            overwrite: true


          \\/.+?\\/var\\/spec_dir\\/desrc.yml
          Overwrite\\? \\(y or n\\) > \\e\\[92mOverwrite\\e\\[0m \\/.+?\\/var\\/spec_dir\\/desrc.yml
          \\z
          STRING
        },
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        delete_dir(spec_case["spec_dir"])
        Dir.mkdir(spec_case["spec_dir"]) unless Dir.exists?(spec_case["spec_dir"])

        file_before_test = spec_case["files_to_create_before_testing"]
        path_before_test = file_before_test[:path]
        string_before_test = file_before_test[:string]
        if !path_before_test.nil? && !string_before_test.nil?
          File.write(path_before_test, string_before_test)
        end

        desrc_file_yaml_str = if !path_before_test.nil? && File.exists?(path_before_test)
                                File.read(path_before_test)
                              else
                                ""
                              end

        des_options = ::Des::Options::Options.new(
          Des::Options::CliOptions.new(spec_case["cli_options"]),
          Des::Options::DesrcFileOptions.from_yaml(desrc_file_yaml_str)
        )

        writer = IO::Memory.new
        reader = IO::Memory.new spec_case["prompt_input_str"]
        file_creator = Des::Cli::FileCreator.new(writer, reader)

        desrc_file = Des::SettingFile::DesrcFile.new(des_options, "#{spec_case["spec_dir"]}/desrc.yml")

        executer = Des::Cli::Executer.new(file_creator, writer)
        executer.create(desrc_file)

        spec_case["expected"]["file_expected_list"].each do |file|
          File.read(file["path"]).should match /#{file["string"]}/
        end

        delete_dir(spec_case["spec_dir"])
        writer.to_s.should match /#{spec_case["expected"]["output_message"]}/
      end
    end
  end
end
