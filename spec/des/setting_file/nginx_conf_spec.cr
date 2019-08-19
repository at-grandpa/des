require "../../spec_helper"

describe Des::SettingFile::NginxConf do
  describe "#to_s" do
    it "return nginx_conf string." do
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

      allow(options_mock).to receive(save_dir).and_return("/path/to/dir")
      allow(options_mock).to receive(overwrite).and_return(false)

      file = Des::SettingFile::NginxConf.new(options_mock)
      actual = file.build_file_create_info
      expected = Des::Cli::FileCreateInfo.new(
        "/path/to/dir/nginx.conf",
        <<-STRING,

        user  nginx;
        worker_processes  1;

        error_log  /var/log/nginx/error.log warn;
        pid        /var/run/nginx.pid;

        events {
            worker_connections  1024;
        }

        http {
            include       /etc/nginx/mime.types;
            default_type  application/octet-stream;

            log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                              '$status $body_bytes_sent "$http_referer" '
                              '"$http_user_agent" "$http_x_forwarded_for"';

            access_log  /var/log/nginx/access.log  main;

            sendfile        on;
            #tcp_nopush     on;

            keepalive_timeout  65;

            #gzip  on;

            server {
                listen 80;

                location / {
                    proxy_pass http://app:3000/;
                }
            }

            include /etc/nginx/conf.d/*.conf;
        }

        STRING
        false
      )

      actual.path.should eq expected.path
      actual.str.should eq expected.str
      actual.overwrite.should eq expected.overwrite
    end
  end
end
