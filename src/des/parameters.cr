require "yaml"

module Des
  class Parameters
    @opts : Des::Opts
    @rc : Des::Rc
    @image : String
    @packages : Array(String)
    @container : String
    @save_dir : String
    @mysql_version : String
    @nginx_version : String
    @docker_compose : YAML::Any

    getter image, packages, container, save_dir, mysql_version, nginx_version, docker_compose

    def initialize(@rc, @opts)
      @image = _find_image
      @packages = _find_packages
      @container = _find_container
      @save_dir = _find_save_dir
      @mysql_version = _find_mysql_version
      @nginx_version = _find_nginx_version
      @docker_compose = _find_docker_compose
    end

    private def _find_image
      image = nil
      image = @rc.image unless @rc.image.nil?
      image = @opts.image unless @opts.image.nil?
      raise "Image name is not set. See 'des -h'" if image.nil?
      image
    end

    private def _find_packages
      packages = nil
      packages = @rc.packages unless @rc.packages.nil?
      packages = @opts.packages unless @opts.packages.nil?
      raise "Packages is not set. See 'des -h'" if packages.nil?
      packages
    end

    private def _find_container
      container = nil
      container = @rc.container unless @rc.container.nil?
      container = @opts.container unless @opts.container.nil?
      raise "Container name is not set. See 'des -h'" if container.nil?
      container
    end

    private def _find_save_dir
      save_dir = nil
      save_dir = @rc.save_dir unless @rc.save_dir.nil?
      save_dir = @opts.save_dir unless @opts.save_dir.nil?
      raise "Save dir is not set. See 'des -h'" if save_dir.nil?
      save_dir
    end

    private def _find_mysql_version
      mysql_version = nil
      mysql_version = @rc.mysql_version unless @rc.mysql_version.nil?
      mysql_version = @opts.mysql_version unless @opts.mysql_version.nil?
      raise "Mysql version is not set. See 'des -h'" if mysql_version.nil?
      mysql_version
    end

    private def _find_nginx_version
      nginx_version = nil
      nginx_version = @rc.nginx_version unless @rc.nginx_version.nil?
      nginx_version = @opts.nginx_version unless @opts.nginx_version.nil?
      raise "Nginx version is not set. See 'des -h'" if nginx_version.nil?
      nginx_version
    end

    private def _find_docker_compose
      default_compose_yaml = <<-YAML
      version: '2'
      services:
        app:
          build: .
      YAML
      default_docker_compose = YAML.parse(default_compose_yaml)
      rc_docker_compose = @rc.docker_compose
      rc_docker_compose.nil? ? default_docker_compose : rc_docker_compose
    end
  end
end
