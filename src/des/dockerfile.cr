module Des
  class Dockerfile
    # @dir : String
    # @filename : String
    @image : String = "ubuntu:latest"
    @packages : Array(String) = [] of String
    @container_name : String = "my_project"
    @rc : Des::Rc
    @opts : Clim::Options::Values

    getter image, packages

    def initialize(@rc, @container_name, @opts)
    end

    def setup_image
      image = @opts.s["image"]
      pattern = "\\A[a-zA-Z][^:]+?(|:[0-9a-zA-Z-\._]+?)\\z"
      unless image.match /#{pattern}/
        raise "Invalid image name pattern. Valid pattern -> /#{pattern}/"
      end
      image
    end

    def setup_packages
      @opts.a["packages"]
    end

    def setup_config_param
      @image = @rc.setting["default_param"]["image"]?.to_s || @image
      @packages = @rc.setting["default_param"]["packages"].to_a || @packages
    end

    def setup_command_param
      @image = setup_image
      @packages = setup_packages
    end

    def create_file
      setup_config_param
      setup_command_param
    end
  end
end
