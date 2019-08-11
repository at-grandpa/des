require "../../spec_helper"

describe Des::SettingFile::NginxConf do
  describe "#to_s" do
    it "return nginx_conf string." do
      options_mock = OptionsMock.new(Des::Options::CliOptions.new, Des::Options::DesRcFileOptions.new)
      nginx_conf = Des::SettingFile::NginxConf.new(options_mock)
      nginx_conf.to_s.should eq <<-STRING

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
    end
  end
end
