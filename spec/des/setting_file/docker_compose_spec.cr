require "../../spec_helper"

describe Des::SettingFile::DockerCompose do
  describe "#to_s" do
    [
      {
        desc:         "return docker_compose default string.",
        mock_setting: {
          container:              "test_container",
          save_dir:               "/path/to/dir",
          docker_compose_version: "4",
          web_app:                false,
          overwrite:              false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/path/to/dir/docker-compose.yml",
          <<-STRING,
          version: '4'
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

          STRING
          false
        ),
      },
      {
        desc:         "return docker_compose default string other parameter version.",
        mock_setting: {
          container:              "hoge_container",
          save_dir:               "/path/to/dir",
          docker_compose_version: "99",
          web_app:                false,
          overwrite:              false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/path/to/dir/docker-compose.yml",
          <<-STRING,
          version: '99'
          services:
            app:
              build: .
              container_name: hoge_container
              restart: always
              stdin_open: true
              volumes:
                - .:/root/hoge_container
              ports:
                - 3000

          STRING
          false
        ),
      },
      {
        desc:         "return docker_compose web_app string.",
        mock_setting: {
          container:              "test_container",
          save_dir:               "/path/to/dir",
          docker_compose_version: "4",
          web_app:                true,
          overwrite:              false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/path/to/dir/docker-compose.yml",
          <<-STRING,
          version: '4'
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

          STRING
          false
        ),
      },
      {
        desc:         "return docker_compose web_app string other parameter version.",
        mock_setting: {
          container:              "hoge_container",
          save_dir:               "/hoge/dir",
          docker_compose_version: "99",
          web_app:                true,
          overwrite:              false,
        },
        expected: Des::Cli::FileCreateInfo.new(
          "/hoge/dir/docker-compose.yml",
          <<-STRING,
          version: '99'
          services:
            app:
              build: .
              container_name: hoge_container
              restart: always
              stdin_open: true
              volumes:
                - .:/root/hoge_container
              ports:
                - 3000
              links:
                - mysql
            mysql:
              image: mysql
              container_name: hoge_container-mysql
              restart: always
              environment:
                MYSQL_ROOT_PASSWORD: root
              ports:
                - 3306
            nginx:
              image: nginx
              container_name: hoge_container-nginx
              restart: always
              volumes:
                - ./nginx.conf:/etc/nginx/nginx.conf
              ports:
                - 80:80
              links:
                - app

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
          docker_compose_version: nil,
          web_app:                nil,
          overwrite:              nil,
        }
        dummy_yaml_str = ""
        options_mock = OptionsMock.new(
          Des::Options::CliOptions.new(dummy_cli_options),
          Des::Options::DesrcFileOptions.from_yaml(dummy_yaml_str)
        )

        allow(options_mock).to receive(container).and_return(spec_case["mock_setting"]["container"])
        allow(options_mock).to receive(save_dir).and_return(spec_case["mock_setting"]["save_dir"])
        allow(options_mock).to receive(docker_compose_version).and_return(spec_case["mock_setting"]["docker_compose_version"])
        allow(options_mock).to receive(web_app).and_return(spec_case["mock_setting"]["web_app"])
        allow(options_mock).to receive(overwrite).and_return(spec_case["mock_setting"]["overwrite"])

        file = Des::SettingFile::DockerCompose.new(options_mock)
        actual = file.build_file_create_info
        expected = spec_case["expected"]

        actual.path.should eq expected.path
        actual.str.should eq expected.str
        actual.overwrite.should eq expected.overwrite
      end
    end
  end
end
