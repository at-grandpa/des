module Des
  class Opts
    def initialize(@opts : Des::CliOptions)
    end

    def image
      image = @opts.image
      return nil if image.nil?
      image_str = image.as(String)
      _validate_image!(image_str)
      image_str
    end

    IMAGE_PATTERN = "\\A[a-zA-Z][^:]+?(|:[0-9a-zA-Z-\._]+?)\\z"

    private def _validate_image!(image)
      unless image.match /#{IMAGE_PATTERN}/
        raise "Invalid image name pattern. Valid pattern -> /#{IMAGE_PATTERN}/"
      end
    end

    def packages
      @opts.packages
    end

    def container
      container = @opts.container
      return nil if container.nil?
      container_str = container.as(String)
      _validate_container!(container_str)
      container_str
    end

    CONTAINER_PATTERN = "\\A[0-9a-zA-Z-_]+?\\z"

    private def _validate_container!(container)
      unless container.match /#{CONTAINER_PATTERN}/
        raise "Invalid container name pattern. Valid pattern -> /#{CONTAINER_PATTERN}/"
      end
    end

    def save_dir
      save_dir = @opts.save_dir
      return nil if save_dir.nil?
      save_dir_str = save_dir.as(String)
      expand_save_dir = File.expand_path(save_dir_str)
      raise "Save dir set as an option is not found. -> #{expand_save_dir}" unless Dir.exists?(expand_save_dir)
      expand_save_dir
    end

    def rc_file
      rc_file = @opts.rc_file
      raise "rc_file path is not set. See 'des --help'" if rc_file.nil?
      rc_file_str = rc_file.as(String)
      rc_file_realpath = File.expand_path(rc_file_str)
      raise "rc_file set as an option is not found. -> #{rc_file_str}" unless File.exists?(rc_file_realpath)
      rc_file_realpath
    end

    def docker_compose_version
      docker_compose_version = @opts.docker_compose_version
      return nil if docker_compose_version.nil?
      docker_compose_version_str = docker_compose_version.as(String)
      _validate_docker_compose_version!(docker_compose_version_str)
      docker_compose_version_str
    end

    DOCKER_COMPOSE_VERSION_PATTERN = "\\A[0-9]+?\\z"

    private def _validate_docker_compose_version!(docker_compose_version)
      unless docker_compose_version.match /#{DOCKER_COMPOSE_VERSION_PATTERN}/
        raise "Invalid docker-compose version pattern. Valid pattern -> /#{DOCKER_COMPOSE_VERSION_PATTERN}/"
      end
    end

    def web_app
      web_app = @opts.web_app
      return nil if web_app.nil?
      web_app.as(Bool)
    end

    def overwrite
      overwrite = @opts.overwrite
      return nil if overwrite.nil?
      overwrite.as(Bool)
    end
  end
end
