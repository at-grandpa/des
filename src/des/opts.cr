module Des
  class Opts
    def initialize(@opts : Clim::Options::Values)
    end

    def image
      image = @opts.s["image"]?
      return nil if image.nil?
      _validate_image!(image)
      image
    end

    IMAGE_PATTERN = "\\A[a-zA-Z][^:]+?(|:[0-9a-zA-Z-\._]+?)\\z"

    private def _validate_image!(image)
      unless image.match /#{IMAGE_PATTERN}/
        raise "Invalid image name pattern. Valid pattern -> /#{IMAGE_PATTERN}/"
      end
    end

    def packages
      packages = @opts.a["packages"]?
      return nil if packages.nil?
      packages
    end

    def container
      container = @opts.s["container"]?
      return nil if container.nil?
      _validate_container!(container)
      container
    end

    CONTAINER_PATTERN = "\\A[0-9a-zA-Z-_]+?\\z"

    private def _validate_container!(container)
      unless container.match /#{CONTAINER_PATTERN}/
        raise "Invalid container name pattern. Valid pattern -> /#{CONTAINER_PATTERN}/"
      end
    end

    def save_dir
      save_dir = @opts.s["save-dir"]?
      return nil if save_dir.nil?
      expand_save_dir = File.expand_path(save_dir)
      raise "Save dir set as an option is not found. -> #{expand_save_dir}" unless Dir.exists?(expand_save_dir)
      expand_save_dir
    end

    def rc_file
      rc_file = @opts.s["rc-file"]?
      raise "rc_file path is not set. See 'des -h'" if rc_file.nil?
      raise "rc_file set as an option is not found. -> #{rc_file}" unless File.exists?(rc_file)
      rc_file
    end

    def mysql_version
      mysql_version = @opts.s["mysql-version"]?
      return nil if mysql_version.nil?
      mysql_version
    end

  end
end
