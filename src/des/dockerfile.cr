require "ecr"

module Des
  class Dockerfile
    FILE_NAME = "Dockerfile"

    @image : String
    @packages : Array(String)
    @container_name : String
    @rc : Des::Rc
    @opts : Des::Opts

    getter image, packages, container_name

    def initialize(@rc, @opts)
      @image = _find_image
      @packages = _find_packages
      @container_name = _find_container_name
    end

    private def _find_image
      image = nil
      image = @rc.image unless @rc.image.nil?
      image = @opts.image unless @opts.image.nil?
      raise "Image name for Dockerfile is not set. See 'des -h'"
      image
    end

    private def _find_image_in_rc
      return nil unless @rc.setting["default_param"]?
      return nil unless @rc.setting["default_param"]["image"]?
      @rc.setting["default_param"]["image"].as_s
    end

    private def _find_image_in_opts
      return @image unless @opts.s["image"]?
      validate_image!(@opts.s["image"])
      @opts.s["image"]
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

    private def _find_packages_in_conf
      return @packages unless @rc.setting["default_param"]?
      return @packages unless @rc.setting["default_param"]["packages"]?
      @rc.setting["default_param"]["packages"].map(&.as_s)
    end

    def update_to_command_param
      @image = _find_image_in_opts
      @packages = _find_packages_in_opts
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
