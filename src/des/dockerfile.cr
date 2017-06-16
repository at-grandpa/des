require "ecr"

module Des
  class Dockerfile
    @dir : String = "."
    @filename : String = "Dockerfile"
    @image : String = "ubuntu:latest"
    @packages : Array(String) = [] of String
    @container_name : String = "my_container"
    @rc : Des::Rc
    @opts : Des::Opts

    getter image, packages

    def initialize(@rc, @opts, @dir = ".")
    end

    def create_file
      update_to_config_param
      update_to_command_param
      create_file
    end

    def update_to_config_param
      @image = _find_image_in_conf
      @packages = _find_packages_in_conf
    end

    private def _find_image_in_conf
      return @image unless @rc.setting["default_param"]?
      return @image unless @rc.setting["default_param"]["image"]?
      @rc.setting["default_param"]["image"].as_s
    end

    private def _find_packages_in_conf
      return @packages unless @rc.setting["default_param"]?
      return @packages unless @rc.setting["default_param"]["packages"]?
      @rc.setting["default_param"]["packages"].map(&.as_s)
    end

    def update_to_command_param
      @image = _find_image_in_opts
      @packages = _find_packages_in_opts
    end

    private def _find_image_in_opts
      return @image unless @opts.s["image"]?
      validate_image!(@opts.s["image"])
      @opts.s["image"]
    end

    def validate_image!(image)
      pattern = "\\A[a-zA-Z][^:]+?(|:[0-9a-zA-Z-\._]+?)\\z"
      unless image.match /#{pattern}/
        raise "Invalid image name pattern. Valid pattern -> /#{pattern}/"
      end
    end

    private def _find_packages_in_opts
      return @packages unless @opts.s["packages"]?
      @opts.a["packages"]
    end

    def create_file(dir = ".")
      File.write("#{dir}/Dockerfile", to_s)
    end

    ECR.def_to_s "#{__DIR__}/dockerfile/template.ecr"
  end
end
