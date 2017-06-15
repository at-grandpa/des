module Des
  class Dockerfile
    # @dir : String
    # @filename : String
    @image : String = "ubuntu"
    @packages : Array(String) = [] of String
    @path : String = "./"
    @project_name : String = "my_project"
    @opts : Clim::Options::Values

    def initialize(@path, @project_name, @opts)
    end

    def setup_ecr_param
      @image = setup_image
      @packages = setup_packages
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
      packages = @opts.a["packages"]
      pattern = "\\A[a-zA-Z][^:]+?(|:[0-9a-zA-Z-\._]+?)\\z"
      unless image.match /#{pattern}/
        raise "Invalid image name pattern. Valid pattern -> /#{pattern}/"
      end
      image
      ["aaa"]
    end

    def create_file
    end
  end
end
