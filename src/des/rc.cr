require "yaml"

module Des
  class Rc

    def initialize(yaml_str)
      @setting = YAML.parse(yaml_str)
    end

    def image
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["image"]?
      @setting["default_param"]["image"].as_s
    end

    def packages
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["packages"]?
      @setting["default_param"]["packages"].map(&.as_s)
    end

    def container_name
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["container_name"]?
      @setting["default_param"]["container_name"].as_s
    end

    def save_dir
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["save_dir"]?
      @setting["default_param"]["save_dir"].as_s
    end

    def rc_file
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["rc_file"]?
      @setting["default_param"]["rc_file"].as_s
    end
  end
end
