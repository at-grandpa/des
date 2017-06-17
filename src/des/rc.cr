require "yaml"

module Des
  class Rc
    def initialize(yaml_str)
      @setting = YAML.parse(yaml_str)
      begin
        @setting.as_h  # rc file format is only allowed in hash format.
      rescue ex
        raise "rc file format is not Hash. Exception -> #{ex.message}"
      end
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
      save_dir = @setting["default_param"]["save_dir"].as_s
      raise "Save dir set as rc_file is not found. -> #{save_dir}" unless Dir.exists?(save_dir)
      save_dir
    end
  end
end
