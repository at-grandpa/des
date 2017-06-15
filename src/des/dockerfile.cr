module Des
  class Dockerfile
    # @dir : String
    # @filename : String
    @image : String
    @packages : Array(String)
    @path : String
    @project_name : String
    @opts : Clim::Options::Values

    def initialize(@path, @project_name, @opts)
      @path = "a"
      @project_name = "a"
      @image = "a"
      @packages = ["a"]
      # setup_ecr_param
    end

    def setup_ecr_param
      @image = setup_image
      @packages = setup_packages
    end

    def setup_image
      image = @opts.s["image"]
      pattern = "\\A[^:]+?(|:[0-9a-zA-Z-\._]+?)\\z"
      unless image.match /#{pattern}/
        raise "Invalid image name pattern. Valid pattern -> /#{pattern}/"
      end
      image
    end

    def setup_packages
      ["aaa"]
    end

    def create_file
    end
  end
end
