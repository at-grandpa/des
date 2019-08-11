require "../../spec_helper"

describe Des::SettingFile::DockerCompose do
  describe "#to_s" do
    [
      {
        desc:         "return docker_compose default string.",
        mock_setting: {
          container:              "test_container",
          docker_compose_version: "4",
          web_app:                false,
        },
        expected: <<-STRING
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
      },
      {
        desc:         "return docker_compose default string other parameter version.",
        mock_setting: {
          container:              "hoge_container",
          docker_compose_version: "99",
          web_app:                false,
        },
        expected: <<-STRING
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
      },
      {
        desc:         "return docker_compose web_app string.",
        mock_setting: {
          container:              "test_container",
          docker_compose_version: "4",
          web_app:                true,
        },
        expected: <<-STRING
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
      },
      {
        desc:         "return docker_compose web_app string other parameter version.",
        mock_setting: {
          container:              "hoge_container",
          docker_compose_version: "99",
          web_app:                true,
        },
        expected: <<-STRING
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
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options_mock = OptionsMock.new(Des::Options::CliOptions.new, Des::Options::DesRcFileOptions.new)
        allow(options_mock).to receive(container).and_return(spec_case["mock_setting"]["container"])
        allow(options_mock).to receive(docker_compose_version).and_return(spec_case["mock_setting"]["docker_compose_version"])
        allow(options_mock).to receive(web_app).and_return(spec_case["mock_setting"]["web_app"])
        docker_compose = Des::SettingFile::DockerCompose.new(options_mock)
        docker_compose.to_s.should eq spec_case["expected"]
      end
    end
  end
end
