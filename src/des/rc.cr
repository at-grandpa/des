require "yaml"

module Des
  class Rc

    def initialize(path)
      raise "No such rc file. -> #{path}" unless File.exists?(path)
      @setting = YAML.parse(File.read(path))
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

    def container_name
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["container_name"]?
      @setting["default_param"]["container_name"].as_s
    end
  end
end
