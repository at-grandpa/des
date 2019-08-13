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
  describe "#execute" do
    [
      {
        desc:        "create all file.",
        cli_options: {
          image:                  "test_image",
          packages:               ["vim", "ping"],
          container:              "test_container",
          save_dir:               "#{__DIR__}/var/spec_dir",
          rc_file:                "#{__DIR__}/var/spec_dir/desrc.yml",
          docker_compose_version: "3",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        files_to_create_before_testing: [] of NamedTuple(path: String, string: String),
        rc_file_str:                    <<-STRING,
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
                rc_file: \\/.+?\\/var\\/spec_dir\\/desrc.yml
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
        desc:        "when an rc_file exists, it is not created.",
        cli_options: {
          image:                  "test_image",
          packages:               ["vim", "ping"],
          container:              "test_container",
          save_dir:               "#{__DIR__}/var/spec_dir",
          rc_file:                "#{__DIR__}/var/spec_dir/desrc.yml",
          docker_compose_version: "3",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
        },
        files_to_create_before_testing: [
          {
            path:   "#{__DIR__}/var/spec_dir/desrc.yml",
            string: "hoge",
          },
        ],
        rc_file_str: <<-STRING,
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
          rc_file:                "#{__DIR__}/var/spec_dir/desrc.yml",
          docker_compose_version: "3",
          web_app:                false,
          overwrite:              false,
          desrc:                  false,
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
        rc_file_str: <<-STRING,
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
          rc_file:                "#{__DIR__}/var/spec_dir/desrc.yml",
          docker_compose_version: "3",
          web_app:                false,
          overwrite:              true,
          desrc:                  false,
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
        rc_file_str: <<-STRING,
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
          rc_file:                "#{__DIR__}/var/spec_dir/desrc.yml",
          docker_compose_version: "3",
          web_app:                true,
          overwrite:              false,
          desrc:                  false,
        },
        files_to_create_before_testing: [
          {
            path:   "#{__DIR__}/var/spec_dir/desrc.yml",
            string: "",
          },
        ],
        rc_file_str: <<-STRING,
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
        desc:        "when desrc flag is true, display desrc file.",
        cli_options: {
          image:                  "test_image",
          packages:               ["vim", "ping"],
          container:              "test_container",
          save_dir:               "#{__DIR__}/var/spec_dir",
          rc_file:                "#{__DIR__}/var/spec_dir/desrc.yml",
          docker_compose_version: "3",
          web_app:                false,
          overwrite:              false,
          desrc:                  true,
        },
        files_to_create_before_testing: [
          {
            path:   "#{__DIR__}/var/spec_dir/desrc.yml",
            string: "Hello, World!!",
          },
        ],
        rc_file_str: <<-STRING,
        STRING
        prompt_input_str: "",
        expected:         {
          file_expected_list: [
            {
              path:   "#{__DIR__}/var/spec_dir/desrc.yml",
              string: <<-STRING,
              \\AHello, World!!\\z
              STRING
            },
          ],
          output_message: <<-STRING,
          \\A
          File path: \\/.+?\\/var\\/spec_dir\\/desrc.yml

          Hello, World!!
          \\z
          STRING
        },
      },
      # rc_file_strが反映されるケース
      # その他のエラーのケース
    ].each do |spec_case|
      it spec_case["desc"] do
        des_options = ::Des::Options::Options.new(
          Des::Options::CliOptions.new(spec_case["cli_options"]),
          Des::Options::DesRcFileOptions.new(spec_case["rc_file_str"])
        )

        writer = IO::Memory.new
        reader = IO::Memory.new spec_case["prompt_input_str"]
        file_creator = Des::Cli::FileCreator.new(writer, reader)

        des_rc_file = Des::SettingFile::DesRcFile.new(
          Des::Options::Options.new(
            Des::Options::CliOptions.new(spec_case["cli_options"]),
            Des::Options::DesRcFileOptions.new("")
          )
        )

        dockerfile = Des::SettingFile::Dockerfile.new(des_options)
        makefile = Des::SettingFile::Makefile.new(des_options)
        docker_compose = Des::SettingFile::DockerCompose.new(des_options)
        nginx_conf = Des::SettingFile::NginxConf.new(des_options)

        delete_dir(des_options.save_dir)
        Dir.mkdir(des_options.save_dir) unless Dir.exists?(des_options.save_dir)

        spec_case["files_to_create_before_testing"].each do |file|
          File.write(file[:path], file[:string])
        end

        executer = Des::Cli::Executer.new(des_options, file_creator, des_rc_file, dockerfile, makefile, docker_compose, nginx_conf, writer)
        executer.execute

        spec_case["expected"]["file_expected_list"].each do |file|
          File.read(file["path"]).should match /#{file["string"]}/
        end

        delete_dir(des_options.save_dir)
        executer.writer.to_s.should match /#{spec_case["expected"]["output_message"]}/
      end
    end
  end
end