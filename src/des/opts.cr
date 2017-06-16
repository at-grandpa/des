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

    def container_name
      container_name = @opts.s["container-name"]?
      return nil if container_name.nil?
      _validate_container_name!(container_name)
      container_name
    end

    CONTAINER_NAME_PATTERN = "\\A[0-9a-zA-Z-_]+?\\z"

    private def _validate_container_name!(container_name)
      unless container_name.match /#{CONTAINER_NAME_PATTERN}/
        raise "Invalid container name pattern. Valid pattern -> /#{CONTAINER_NAME_PATTERN}/"
      end
    end

    def save_dir
      save_dir = @opts.s["save-dir"]?
      return nil if save_dir.nil?
      raise "No such save dir. -> #{save_dir}" unless Dir.exists?(save_dir)
      save_dir
    end

    def rc_file
      rc_file = @opts.s["rc-file"]?
      return nil if rc_file.nil?
      raise "No such rc file. -> #{rc_file}" unless File.exists?(rc_file)
      rc_file
    end

    def packages
      packages = @opts.a["packages"]?
      return nil if packages.nil?
      packages
    end

  end
end
